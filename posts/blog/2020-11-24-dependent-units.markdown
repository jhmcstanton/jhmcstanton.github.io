---
title: Dependent Units of Measure
---

Recently I have been thinking about what a simple implementation of dependent
units of measure would look like. When working with a handful of values with various
units it is easy to make a mistake with a calculation or conversion simply
because they typically have a shared or similar underlying primitive type.
The goal with this post is to make a simple module for working with values
of known units and composing them together.

If you are interested in following along, this post is a literate idris file.
You need either idris or idris2 installed, then just copy and paste this into
a file with extension `.lidr` to try it out!

## Motivation

Here's a contrived example; imagine a simple haskell function to calculate speed:

```haskell
speed :: Fractional a => a -> a -> a
speed length time = length / time
```

This works just fine, although the type is a little opaque. A more complicated
function could also face issues during a refactor since those types are the same,
what if the variables were swapped?

```haskell
speed :: Fractional a => a -> a -> a
speed length time = time / length
```

Clearly this is overly simplified, but these things happen in larger functions and
code bases (at least to me). A common fix for this is to create new types for
all the types your code base works in - even Java programmers uses this approach.

```haskell
newtype Length a = Length { unlength :: a }
newtype Time   a = Time   { untime   :: a }
newtype Speed  a = Speed  { unspeed  :: a }

speed :: Fractional a => Length a -> Time a -> Speed a
speed length time = Speed (unlength l / unlength t)
```

This is quite a bit better:

- Each parameter has its own type so its hard to mix them up
- The return type is also specific and enforces that the implementation
  acknowledges it
- The type is clearer at a glance

This approach works well in practice, and can be seen in many code bases. It
can still be goofed, but using the record datatype should make that harder to do
and easier to resolve in the event that it happens. In general, I would
recommend just going with this approach.

But what if we wanted an even more type safe approach, just for fun? That's what
the next section tries to accomplish.

## Implementation

Here is where the idris code comes in. We'll define a few data types to try
tagging and composing together types by their measure.

### A Handful of Types

```idris
> data BaseMeasure =
>   Time | Length | Mass | Current | Temperatue | Lumin | SubstanceAmount
```

Here `BaseMeasure` is a simple data type to represent the various base quantities
as defined by SI.

```idris
> infix 3 <<*>>,<</>>,<<^>>
> data Measure : Type where 
>   M   : BaseMeasure            -> Measure
>   (<<*>>) : Measure -> Measure -> Measure
>   (<</>>) : Measure -> Measure -> Measure
>   (<<^>>) : Measure -> Int     -> Measure
```

Next `Measure` is defined to compose together `BaseMeasures` to create compound
measurements types. These can be composed like so:

```idris
> Speed : Measure
> Speed = M Length <</>> M Time
```

So far all we have are units without values. Let's make another type for that.

```idris
> data Value : Type -> Measure -> Type where
>   V : a -> Value a measure
```

This datatype is a vessel for a value and its (type level) measure. Note that
the constructor does not carry around the measurement, it is a purely type
level value. `Value` is used like this

```idris
carSpeed : Value Int Speed
carSpeed = V 10
```

Alright, so now we have a way to build up types, but we can't do anything more
with them than the haskell example above. Now we need to implement some value
level operators.

### Basic Operators

So now to implement the operators we will start with addition and
subtraction. These do not affect units so they are straight forward.

```idris
> infix 3 <++>,<->
> (<++>) : Num a => Value a m -> Value a m -> Value a m
> (V a) <++> (V b) = V (a + b)
>
> (<->) : Neg a => Value a m -> Value a m -> Value a m
> (V a) <-> (V b) = V (a - b)
```

Next lets implement unit affecting operators.

```idris
> infix 3 <*>,</>,<^>
> (<*>) : Num a => Value a m1 -> Value a m2 -> Value a (m1 <<*>> m2)
> (V a) <*> (V b) = V (a * b)
>
> (</>) : Fractional a => Value a m1 -> Value a m2 -> Value a (m1 <</>> m2)
> (V a) </> (V b) = V (a / b)
```

These operators will perform the expected mathematical operators on the
underlying numeric representation _and on the units themselves_. In other
words, the operator `<*>` says "give me two values with any two units and 
I'll give you back their values _and_ units multiplied." When using these
operators you will always get back the expected units.

Let's try making a `speed` function with these.

```idis
> speed : Fractional a => Value a (M Length) -> Value a (M Time) -> Value a Speed
> speed length time = length </> time
```

So this _final_ implementation requires the caller to provide a length and time
and then the implementation can't screw up the operation by mishandling
values - here if length and time are swapped a compile time error occurs:

```
When unifying Value a (M Time <</>> M Time) and Value a Speed
Mismatch between:
        Time
and
        Length
at:
133
                            ^^^^^^^^^^^^^^^
```

## Conclusion


This is a super minimal example of how to build a type safe library for working
with units of measure. It's incomplete for a real-life use: a number of
operators are missing, it could use a `reduce` function to simplify units
after each operation, and really ought to provide proof helpers for convincing
idris that two units that are mathematically the same, but structurally
different, are the same (idris would not believe that
`Time <<*>> Temperature` and `Temperature <<*>> Time` are the same without some
coaxing).

While writing this I ran into a library with similar goals as this post, but
more fleshed out and complete. If you're interested in more examples defintely
check out [the quantities library](https://github.com/timjb/quantities).

Hopefully this gives you some ideas of how to use types in different ways in
your projects, even if it is "just" wrapping your inputs in explicit types
like in the haskell example. I mean, that's what I would do.
