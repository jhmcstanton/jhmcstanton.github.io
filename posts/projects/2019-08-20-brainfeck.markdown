---
title: Brainfeck
---

[`Brainfeck`](https://github.com/jhmcstanton/brainfeck/) is yet another
brainfuck implementation. The web UI can be found [over here](https://www.jhmcstanton.com/brainfeck/).

`Brainfeck` is just an excuse to use [idris](https://www.idris-lang.org/) for a
toy project since I've been working through
[_Type-Driven Devlopment with Idris_](https://www.manning.com/books/type-driven-development-with-idris). Brainfuck is an incredibly simple language so using
a fully dependently typed language to implement it seemed like over-kill
(and the implementation is _quite large_), but it's been a solid learning
experience to apply first-class dependent types to this project. I've also been rooting around
on the idris homepage, and there are some pretty cool features in the language.

## ST

Idris supported a module for some time called [`effects`](http://docs.idris-lang.org/en/latest/effects/introduction.html) that supported defining actions
that could run specific operations, such as interacting with STDIO. This
has since been deprecated in favor of [`st`](http://docs.idris-lang.org/en/latest/st/), which apparently composes better and supports tracking resource usage
and consumption (I say "apparently" because I never actually used `effects`).

`ST` is similar to Haskell's [ST monad](http://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Monad-ST.html). Both support running a typically
stateful operation that returns a pure value by ensuring the unsafe state
never escapes. Idris' implementation has a few features that make working with complex
types pretty awesome.

First off, the `STrans` definition

```idris
STrans : (m : Type -> Type) ->
         (resultType : Type) ->
         (in_res : Resources) ->
         (out_res : resultType -> Resources) ->
         Type
```

supports updating a resource's type based on the output of an action. This is
essentially a requirement for doing anything not completely trivial with
a dependently typed data structure. For example, a `Vect (n : Nat) a` may
grow or shrink based on the operation. Without being able to update the
type of the `Vect` this would be an invalid operation.

Idris' ST additionally defines the mutable state as a list of resources,
instead of a single field. In Haskell's ST this would be encoded using a
product type of some sort. Idris's implementation is both pretty
dang convenient for getting at the mutable variables and
composing stateful operations with differing, but related, resources.

```idris
operation1 : (strs : Var) -> ST m String [ strs ::: State (Vect (S k) String) ]
operation1 strs = ...

operation2 : (index : Var) -> (strs : Var) -> ST m String [ index ::: State Int,
                                                            strs  ::: State (Vect (S k) String) ]
operation2 index strs = ...
```
Here the functions `operation1` and `operation2` are stateful operations that each return
a `String.` `operation1` has a mutable variable, `strs`, that is a non-empty `Vect` of `String`.
`operation2` has the same mutable variable plus an additional variable, `index`, that is simply
a mutable `Int`. `Strans` allows `operation1` to be called from within `operation2` since it
uses a subset of the same resources, but not the other way around. This allows the programmer
to minimize the amount of state that is threaded around when many resources are required.

One caveat with this more sophisticated ST implementation is that the error messages
can get fairly confusing, especially where resources are being created. In general this
isn't a large issue since resources weren't created often for this project, just
the beginning of program interpretation, but it was a bit of a hurdle.

## Flexible FFI

Idris has a very flexible foreign function interface, including official support for javascript.
This project is broken up into three parts to take advantage of this:

- `brainfeck-lib`: the main implementation of the interpreter that is backend agnostic.
- `brainfeck-cli`: a c-backend implementation that operates in the default `IO` monad.
- `brainfeck-web`: which uses the javascript backend.

I was delightfully surprised at how simple dropping in the js backend is to do.
```idris
clear : () -> JS_IO ()
clear _ = do
  foreign FFI_JS "document.getElementById(%0).value = ''"
                 (String -> JS_IO ())
                 myAwesomeElementId
```
Interacting with javascript is as simple as providing a javascript statement as a String,
providing the `Type` that is expected to fill in the blanks of that statement, then finally
filling in those blanks. This FFI even supports marshalling idris functions into js functions.

## Future Work

I'm still working through _Type-Driven Development_, and I'll probably make a few changes
to `brainfeck` as I learn more. The current implementation uses some simple types to enforce
that a function can only be run in specific states (non-nil instruction lists, the tape is in
the correct position to shift, etc), but there's probably better ways to encode some of these
things. In general I plan on applying depdendent types to other toy projects.

After using the js FFI with idris I would also strongly consider using it for other toy projects.
I'm not particularly interested in web development (see this site as an example), but this
makes it much more enjoyable. Being able to basically just drop the `brainfeck-lib` package
into a browser was a pretty nice bonus as well.
