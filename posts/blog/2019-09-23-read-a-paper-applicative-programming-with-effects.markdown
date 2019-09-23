---
title: 'Read a Paper: Applicative Programming with Effects'
---

Maybe it's just because I learned about Monads before Applicative Functors, but
I periodically like to refresh on applicative functor motivation. When working
with datatypes that have implement the Monad interface its pretty easy to 
just drop into `do` notation, with the occasional `fmap`, totally skipping over
Applicative. This is unfortunate because the Applicative interface
will often offer a much cleaner solution to the same problem solved with
`bind.`

Applicative functors were first formally introduced to the functional
programming community in 2008 in the functional pearl
[_Applicative Programming with Effects_](http://www.staff.city.ac.uk/~ross/papers/Applicative.html)
by Conor McBride and Ross Paterson. This brief paper serves to highlight
a common pattern spotted in the FP community, namely _idiomatic_ application
of pure functions to values in effectful contexts. _Idiomatic_ here means
that the context provides the ad-hoc definition of what function application
entails.

The goal with this post is not to rewrite or reword this classic paper, but
more to play around with the applicative definition described in the paper. 

## Idiomatic Application

Consider adding two random integers using the Monad interface.

```haskell
import System.Random

randomAdd :: IO Integer
randomAdd = do
  x <- randomIO
  y <- randomIO
  pure (x + y)
```

Pretty typical monadic code. Now recall the [the applicative interface.](https://wiki.haskell.org/Typeclassopedia#Applicative)

```haskell
class Functor f => Applicative f where
  pure  ::                 a -> f a
  (<*>) :: f (a -> b) -> f a -> f b 
```

App, `(<*>)`, is very similar in shape to `fmap`, but allows for combining effects
with pure computations. `randomAdd` can be rewritten more concisely using the 
applicative interface:

```haskell
randomAdd :: IO Integer
randomAdd = pure (+) <*> randomIO <*> randomIO
```

Conor and Ross point out that application like `randomAdd` have a similar shape to
pure function application and introduced _idiom brackets_ to mirror it even more
so.

## Idiom Brackets

Using the authors' notation, `randomAdd` becomes
```
randomAdd = [[ (+) randomIO randomIO ]]
```

Unfortunately for us, GHC doesn't support this syntactic sugar out of the box.
There are various approaches to add this syntax to GHC, from some [type class
hacking found in the haskell wiki](https://wiki.haskell.org/Idiom_brackets), to
a [Haskell preprocessor written by Conor](https://personal.cis.strath.ac.uk/conor.mcbride/pub/she/),
athough this supports much more than just idiom brackets. The approach I took
was to learn a _tiny_ bit of template haskell to make dollar menu style idiom
brackets.

### TH to the Rescue

A quasiquoter to support budget idiom brackets is surprisingly simple,
although it took me an embarassingly long time to write. I'm not going to dig
too deeply into the details since I'm not a template haskell expert _at all_,
but the code [can be found here](https://github.com/jhmcstanton/haskell-sandbox/blob/master/src/TH/App.hs).
This code isn't available in a library, but to play with it just include the
module in your project, import it, and enable the extension `QuasiQuotes`.

Note that these are super-low budget quasiquotes, but they get the job done
pretty frequently. The quoter assumes that each word or token provided to
the quoter is a name in the local scope - arbitrary expressions are definitely
not supported. `randomAdd` can be rewritten like this:

```haskell
randomAdd = [a| + randomIO randomIO |]
```

This quoter doesn't support operators in a terribly Haskell-like way, but I tend to
agree with Ross and Conor that idriom brackets are more convenient than repeated
applications of `(<*>)`. Beyond convenience this syntax also allows the
programmer to convey more of what they want and less how to get there,
clarifying intent in code. 

## Limitations of Applicative

Consider the following Monadic code

```haskell
leftOrRight :: Maybe Bool -> Maybe a -> Maybe a -> Maybe a
leftOrRight bool l r = bool >>= \b -> if b then l else r
```

This code either runs the `l` computation or the `r` computation
based on the `bool` computation. 

```
λ> leftOrRight Nothing (Just 10) (Just 100)
Nothing -- entire computation fails due to failed boolean computation
λ> leftOrRight (Just True) (Just 10) (Just 100)
Just 10
λ> leftOrRight (Just True) Nothing (Just 100)
Nothing -- Failed computation returned
λ> leftOrRight (Just False) (Just 10) (Just 100)
Just 100
λ> leftOrRight (Just False) Nothing (Just 100)
Just 100

```

Here's a similar function using the applicative interface:

```haskell
leftOrRightA :: Maybe Bool -> Maybe a -> Maybe a -> Maybe a
leftOrRightA bool l r = [a| lOrR bool l r ] where
  lOrR True  l _ = l
  lOrR False _ r = r


λ> leftOrRightA Nothing (Just 100) (Just 200)
Nothing
λ> leftOrRightA (Just True) (Just 100) (Just 200)
Just 100
λ> leftOrRightA (Just True) Nothing (Just 200)
Nothing -- failed due to matching branch failing
λ> leftOrRightA (Just False) Nothing (Just 200)
Nothing -- failed due to opposite branch failing
```

The applicative version always runs every computation, capturing all
effects in the process. The result of the applicative action can depend
on earlier values but the effects can not. This is in contrast with
Monad which allows the effects of the computation to depend on earlier
effects as well.

There are upsides to this limitation though. The paper includes a definition
of a purely applicative `Either` type

```haskell
data Except err a = OK a | Failed err

instance Monoid err => Applicative (Except err) where
  pure                       = OK
  OK f <*> OK x              = OK (f x)
  OK f <*> Failed err        = Failed err
  Failed err <*> Ok x        = Failed err
  -- The interesting bit
  Failed err <*> Failed err2 = Failed (err <> err2)
```

In contrast with the monadic version of `Either`, this take on `Either` supports
collecting every error produced by various subcomputations into a single exception.
The monadic version can't support this since the bind operation would be missing
a value to pass - it must abort on the first failed computation.

# Conclusions

_Applicative Programming with Effects_ covers a lot of ground in a few pages
that many haskell programmers should become familiar with. This post didn't
cover the full details, some of which aren't as relevant today, and some of which
I simply don't have enough of a background to grasp. The authors specically
compare and contrast applicative with arrows, which are a bit more general than
applicative. Today arrows are used much less often, but occasionally there is a
novel application for them. The authors also dug into explaining applicative with
category theory which I don't have any background in at all, but may benefit
readers from a different academic background.

For the every day haskell programmer applicative is just another nice tool for the
tool box. Consider pulling it out when you notice that your monadic code is
performing several completely independent effectful computations and you may get
some added clarity and conciseness. GHC 8 also supports [applicative do notation](https://gitlab.haskell.org/ghc/ghc/wikis/applicative-do)
these days, which may be of interest to some readers. I haven't enabled the
extension myself, but for its original use case (supporting an applicative
eDSL) it seems like a decent approach.
