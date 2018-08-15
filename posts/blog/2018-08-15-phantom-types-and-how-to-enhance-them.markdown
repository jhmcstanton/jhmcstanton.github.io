---
title: Phantom Types and How to Enhance Them
---


In an [earlier post about `config-joiner-json`](../projects/2018-07-31-config-joiner-json.html#spooky-types) I briefly mentioned _phantom types_ and
the reason they are used in `config-joiner-json`. The goal in this post is to explain a little more about phantom types and small ways they can be
enhanced to help create better defined programs. 

If you are already familiar with phantom types just jump ahead to [enhancing-phantom-types](#enhancing-phantom-types).

# Phantom Types

## What is it again? 

A _Phantom type_ is just a type parameter that appears in the _type_ constructor, but not in the _data_ constructor for that type. That is to say,
it appears only at the type level. This is more obvious in an examples. 


```haskell
newtype NotSpookyType a = NotSpookyData a -- Not a phantom type! 
```

Here `NotSpooky` is a very normal Haskell `newtype` declaration. The type parameter `a` appears in the type constructor, `NotSpookyType`, and
is in the actual data constructor as well, `NotSpookyData`. At run time the `a` is actually present in all non-bottom `NotSpookyTypes` constructed. 

```haskell
newtype SpookyType a = SpookyType Int -- Phantom Type!
```

Here `SpookyType` is making use of a phantom type, `a`. Notice that all constructed `SpookyTypes` will actually be wrapping an `Int`, regardless of
what type is supplied as the argument to `SpookyType`. All the `a` is doing here is allowing the programmer to tag an arbitrary type on any constructed
`SpookyTypes` for some additional information.

In addition, newtypes that include a phantom type parameter have the added benefit of being able to support many type classes, such as `Functor` 

```haskell
instance Functor SpookyType where
  fmap f (SpookyType n) = SpookyType n
```

Obviously, these instances aren't going to actually _do_ much, but it does give the programmer access to a lot of extra tools for these data types. 

## What's the point? 

Phantom types can be used for many things, although the canonical and frequent use case is to encode a state on the type carrying the phantom around.
This is exactly how `config-joiner-json` is making use of phantom types today, so that will be the example here.

## Starting Off

In our library, `config-joiner-json`, we make extensive use of JSON values - reading them, joining them, etc. Due to the nature of the library 
functions will frequently take two JSON values as argument to *process* them, but the two values are definitely different primitives.  

```haskell
type JSON            = ... 

-- | combines a common configuration with a specific configuration into a full configuration 
combine :: JSON -> JSON -> JSON
```

At first glance this function doesn't offer a whole lot of insight (admittedly the documentation is sparse), but, what's worse, is that 
we can trivially make mistakes with this API by swapping the order of arguments.  

Since we're careful programmers and want to differentiate between the _common_ and an _environment_ JSON values, we create `newtypes` of them.

```haskell
type JSON            = ... 

-- |A config containing common values used across multiple environments
newtype CommonConfig = CommonConfig JSON

-- |A config containing some or all environment specific values
newtype EnvConfig    = EnvConfig JSON

-- | combines a common configuration with a specific configuration into a full configuration 
combine :: CommonConfig -> EnvConfig -> EnvConfig
combine = ...
```

So far so good, the ordering problem is gone and now we can create a fully processed environment config in a more obvious manner. 
Notice, though, that we still have `EnvConfig` in a couple of places. This type describes the primitive "a configuration for a specific environment",
but not if it is ready to be used in that environment (containing all required values). A user could still make odd mistakes with this type as well.


```haskell
readCommonConfig :: IO CommonConfig
readCommonConfig = ...

readEnvConfig :: IO EnvConfig
readEnvConfig = ...

writeEnvConfig :: EnvConfig -> IO ()
writeEnvConfig = ...

main = do
  commonConfig <- readCommonConfig
  envConfig <- readEnvConfig
  let fullConfig = combine commonConfig envConfig
  writeEnvConfig envConfig -- oops! Breaks at runtime
```

One solution to this would just be to add another type. Types are free after all, so let's try it.


```haskell
type JSON                   = ... 

-- |A config containing common values used across multiple environments
newtype CommonConfig        = CommonConfig JSON

-- |A config containing some or all environment specific values that still needs to be processed
newtype PreProcessEnvConfig = PreProcessEnvConfig JSON

-- |A config containing all environment specific values that is ready to be used
newtype ProcessedEnvConfig  = ProcessesEnvConfig JSON

-- | combines a common configuration with a specific configuration into a full configuration 
combine :: CommonConfig -> PreProcessEnvConfig -> PostProcessEnvConfig
combine = ...
```

This solution actually works fine. All arguments have separate types for their specific use cases, and the user can't accidentally
reuse an environment JSON value that hasn't been processed when they really want the fully processed value. There are a few draw backs though.
First, we now no longer can write functions that operate on all environment config types regardless of their processing status (unless
we wrote a type class for that, but we would still need an instance per type). Second, as the number of states grow the number of newtypes
must grow lock-step with them. Here we are encoding each state as a new `EnvConfig` type,
when we really have a single `EnvConfig` primitive whose state we want to track at the type level.

## Phantom Type Approach

Instead of encoding our states as unique `newtypes`, we want to tag our one type with different states.

```haskell
{-# LANGUAGE EmptyDataDecls #-}
type JSON                   = ... 

-- |A config containing common values used across multiple environments
newtype CommonConfig        = CommonConfig JSON

-- |The tagged type is not yet processed
data PreProcess              -- note, this has no constructor

-- |The tagged type is processed
data PostProcess             -- note, this has no constructor

-- |A config containing some or all environment specific value
newtype EnvConfig a          = EnvConfig JSON

-- | combines a common configuration with a specific configuration into a full configuration 
combine :: CommonConfig -> EnvConfig PreProcess -> EnvConfig PostProcess
combine = ...
```

Above is the encoding use phantom types. There are a few changes here. First, we are back to just a single `newtype` for environment
configurations, `EnvConfig`, that includes `a` for encoding its state. Second is the new state-tracking types, `PreProcess`, and `PostProcess`. 
These are making use of the `EmptyDataDecls` extension so that that do not include any data constructor at all - they only exist at the
type level. 

This approach turns out to be rather convenient. First, we can write functions that operate on all `EnvConfigs` trivially:


```haskell
envConfigTransform :: EnvConfig a -> EnvConfig a
envConfigTransform = ... 
```

Second, callers can't accidentally reuse a `PreProcess` config when a `PostProcess` config is required, assuming the API is making use of these types:

```haskell
readCommonConfig :: IO CommonConfig
readCommonConfig = ...

readEnvConfig :: IO EnvConfig PreProcess
readEnvConfig = ...

writeEnvConfig :: EnvConfig PostProcess -> IO ()
writeEnvConfig = ...

main = do
  commonConfig <- readCommonConfig
  envConfig <- readEnvConfig
  let fullConfig = combine commonConfig envConfig
  writeEnvConfig envConfig -- doesn't compile! Success!
```

Finally, if we add new types that must be supported we just make a new empty data declaration and all the generic functions we wrote just work! Not too bad.

## Enhancing Phantom Types

By now you should hopefully have a decent idea about what phantom types are and when you might use them. An attentive reader may notice something 
at odds with phantom types and the way we typically make use of `newtypes` in Haskell programs.


```haskell
newtype EnvConfig a = EnvConfig JSON
```

In Haskell we typically attempt to minimize the number of valid states in a program as much as possible, leveraging `newtypes` and `data` types
along the way to attempt to capture the very specific states desired. Type parameters, on the other hand, are generalized extremely broadly. Typically
that makes sense, there isn't usually a use case for a `List` that only contains `Num` instances, for example.

```haskell
data [] (Num a) => a = [] | a : [a] -- hypothetical syntax, not actually supported in standard Haskell
```

However, in the use case above for phantom types we _are_ attempting to have a very small number of types that can be used as an encoding. This is where
`DataKinds` come in.

### DataKinds

For those who haven't bumped into `DataKinds` before, it is an extension that lifts type constructors to the kind level and data constructors to the type level. 
Let's break that down really quick.

#### Kinds
A _kind_ is a type of a type, generally represented as a `*` in Haskell but also `Type` after GHC 8.0. So `Int` has a _kind_ of `*`. Types that take
other types as arguments have a different kind. For example, `Maybe` has kind `* -> *`

#### Type Constructors 
A type constructor is a type that takes other types as arguments to create a concrete type. `Maybe` and `[]` are type constructors.

#### Data Constructors
A data constructor constructs a _value_ of a _type_. `Just` is a data constructor of `Maybe a` with type `Just :: a -> Maybe a`


The `DataKinds` extension basically lets us use Data Constructors where we are using types, and Type Constructors where we are using kinds. 
Like most extensions in GHC, this has many applications and I definitely encourage you to try this extension out.`` 

### Phantom Types with Data Kinds

So how does `DataKinds` figure into our state encoding? We're going to refactor `EnvConfig` to be parameterized on a type with a more limited kind
than `*`, which is the type of all types. 

```haskell
{-# LANGUAGE DataKinds      #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE GADTs          #-}

-- |Current processing state of the file. 
data ProcessState :: * where
  -- |Indicates that the tagged type has not been processed
  PreProcess  :: ProcessState
  -- |Indicates that the tagged type has been processed
  PostProcess :: ProcessState
  
newtype EnvConfig (a :: ProcessState) = EnvConfig { envValue :: Value }
```

There are really only two changes here. First, notice that `PreProcess` and `PostProcess` have been combined into one single type, `ProcessState`. They
are both still empty data declarations, so we can't make values out of them, so not too much has changed there. Second, the parameter `a` on `EnvConfig` now
has this extra weird annotation on it: `a :: ProcessState.` This can be read as "a has kind `ProcessState`". Remember that typically the kind of a type
like this would be `*`, and with the above extensions turned on we can actually use annotate our type parameter with that kind signature on our previous
implementation:

```haskell
-- old newtype with kind signature
newtype EnvConfig (a :: *) = EnvConfig { envValue :: Value }
```

With the type parameter `a` limited to the kind `ProcessState`, there are only two possible types that can be provided as type arguments: `PreProcess` and
`PostProcess`, the data constructors for the type `ProcessState`. The gain here is that whenever we write a general function the generality of the type
arguments is limited to exactly one of these two states here. Additionally, we only have to change a little syntax on our `combine` function.

```haskell
combine :: CommonConfig -> EnvConfig 'PreProcess -> EnvConfig 'PostProcess
```

the ticks here are just to differentiate that these data constructors are in fact being used as types. We also know in any general
function that we write for arbitrary `EnvConfigs` 

```haskell
envConfigTransform :: EnvConfig a -> EnvConfig a
envConfigTransform = ... 
```

that the `EnvConfig` has a very precise state for a as well. 

Finally, extending supported states is still just as simple as adding new empty data declarations, we just need to include them as data declarations
on the type `ProcessState.`

