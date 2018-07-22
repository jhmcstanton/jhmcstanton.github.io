---
title: A Case for Higher-Kinded Types
---

# What are Higher-Kinded Types?

Higher-kinded types are a feature in languages like Haskell and Scala that come up in interfaces frequently but users don't have to think about a lot. An example interface that uses higher kinded types is `functor`:


```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```

The `f` in the definition above is a higher kinded type. Notice that `f` is applied to the other type variables `a`, and `b` like so:

```haskell
f a
```

`f` here is often called a `type constructor` or a `type operator`. Examples of types that implement the `Functor` type class are `Maybe` and the list type,  `[]`


```haskell
data Maybe a = Nothing | Just a

data [] a = [] | a : [] -- Just an example, [] has its own special syntax

instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing = Nothing
  fmap f (Just x) = Just (f x)
  

instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ [] = []
  fmap f (x : xs) = f x : fmap f xs
```

note that the in the instance header `instance Functor Maybe where` the `Maybe` is just a type constructor / operator and not a fully fledged type. It is not until the function declaration below that a variable is passed to the type constructor maybe to make it a full type: `Maybe a` or `Maybe Int`. 

# Type Constructors in Other Languages

Many languages today support generics, but few support higher kinded types. For example, in Java `List` is a type operator:


```java
List<Integer> xs = new ArrayList<>();
```

Here `List` is parameterized with `Integer` to make a List of Integers, no big deal. 

An unapplied type constructor in Java is a [_raw type_](https://docs.oracle.com/javase/tutorial/java/generics/rawTypes.html). These are only for backwards compatibility and can cause run time errors due to lack of type safety.

# So what?
When writing in other languages I don't frequently miss higher kinded types, but when it comes up it is a huge pain.  

