---
title: Dependent Units
---

Recently I have been thinking about what a simple implementation of dependent
units would look like. When working with a handful of values with various
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

Clearly, this overly simplified, but these things happen in larger functions and
code bases (at least to me). A common fix for this is to create new types for
all the types your code base works in (even Java uses this approach).

```haskell
newtype Length a = Length { unlength :: a }
newtype Time   a = Time   { untime   :: a }
newtype Speed  a = Speed  { unspeed  :: a }

speed :: Fractional a => Length a -> Time a -> Speed a
speed length time = Speed (unlength l / unlength t)
```

This is quite a bit better:
- Each parameter has its own type so its hard to mix them up
- The return type is also specific and harder to mess up
- The type is clearer

This approach works well in practice, and can be seen in many code bases. It
can still be messed up, but using the record datatype makes that at least more
obvious. In general, I would reccommend just going with this approach.

But what if we wanted an even more type safe approach, just for fun? That's what
the next section tries to accomplish.

## Implementation

Here is where the idris code comes in. We'll define a few data types to try
tagging and composing together types by their measure.

### A Handful of Types

```idris
> data BaseMeasure =
>   Time | Length | Mass | Current | Temperatue | Lumin | SubstanceAmount | Scalar
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

So far all we have are types without scalar values. Let's make another type for
that.

```idris
> data Value : Type -> Measure -> Type where
>   V : a -> Value a measure
```

This datatype is a vessel for a value and its (type level) measure. Note that
the constructor does not carry around the measurement, it is a purely type
level value. `Values` is used like this

```idris
carSpeed : Value Int Speed
carSpeed = V 10
```

Alright, so now we have a way to build up types, but we can't do anything more
with them than the haskell example above. Now we need to implement some value
level operators.

### Basic Operators

So now to implement the operators we will start with the basic addition and
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
underlying numeric representation and on the units themselves. Let's
try making a `speed` function with these.

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

This is a super minimal example of how to build out a type safe library for
working with units. It could be extended quite a bit - compound units ought
to be simplified (units with the same measure in the divisor in dividend
cancel out, for example). Obviously more operations are needed as well, and I
encourage you to try extending this if you're interested. If you are looking
for more example you can check out 
[the quantities library](https://github.com/timjb/quantities). It is an actually
usable idris library that has similar goals to this post, complete with user
creatable measurements and unit conversions. Definitely worth a look.

Hopefully this gives you some ideas of how to use types in different ways in
your projects, even if it is "just" wrapping your inputs in explicit types
like in the haskell example. I mean, that's what I would do.
