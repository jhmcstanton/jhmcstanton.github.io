---
title: Literate Posts with Diagrams
---

Recently I have been thinking about working on a blog post about
designing programs using iterations of finite state machines as
the specification. Naturally this should include diagrams of said
machines. After searching around, one of the nicer programs for building
these was [this simple SPA](http://madebyevan.com/fsm/), but this one
didn't work for me once there were multiple transitions that could exist
between the same nodes (although, I definitely recommend it!).

This seemed like a good use case for
[`diagrams`](http://hackage.haskell.org/package/diagrams). Instead
of building a diagrams definitions per blog post and manually ensuring
the generated images are included with my site build, I figured
why not just write
[literate Haskell](https://wiki.haskell.org/Literate_programming) posts
to describe the diagrams needed in the post itself and run the post
as a Haskell program when my Hakyll site generater runs.

So that's what this post is - a first literate post using some new tooling
in my Hakyll site generator. The literate post leverages new library
code written for this purpose that should be relatively easy to apply
to other Hakyll sites.

<h2>Creating a Literate Post Module</h2>

The first thing is to create a library module of common functionality that literate
posts may use. Note, in general this module isn't meant for _readers_ of
the post, and is merely a handy module for the writer of the post. Contents
of the post are likely to be runnable by the reader, and are possibly
illustrative for them, but the entire program is for site generation.

```haskell
module Site.Posts.Literate
  (
    module Diagrams.Prelude
  , module Diagrams.Backend.SVG -- your favorite backend here
  )
  where

import           Diagrams.Prelude
import           Diagrams.Backend.SVG
```

First things first - reexport `diagrams` from our literate module. This
includes all the common `diagrams` functionality plus the ability
to render the descriptions into SVGs.

Make sure to include `diagrams` in your <package>.cabal:

```
  build-depends:     base          == 4.*
  ----------------------------------------------
                   , diagrams
                   , diagrams-lib
                   , diagrams-contrib
                   , diagrams-core
                   , diagrams-svg
  ----------------------------------------------
                   , directory
```

`diagrams` reexports all the packages found underneath it but
for whatever reason stack wasn't picking those up... Not a big deal,
just a heads up.

Additionally, we may want to be able to write other resources besides
just diagrams. Let's create some helpers for that.


```haskell
-- |Analagous to a 'System.IO.IOMode', but only
-- supports write and append modes.
data ResourceMode = RWriteMode | RAppendMode
```

As noted in the comment, this is a simplified
[`IOMode`](http://hackage.haskell.org/package/base-4.12.0.0/docs/System-IO.html#t:IOMode)
data type. Currently I don't plan on reading any external resources
from literate posts, so these helpers just remove that possibility. If
you have that requirement, just reuse `IOMode.`

```haskell
resourceToIOMode :: ResourceMode -> IOMode
resourceToIOMode RWriteMode  = WriteMode
resourceToIOMode RAppendMode = AppendMode

overwriteWithFile :: FilePath -> (Handle -> IO r) -> IO r
overwriteWithFile f = withFile f RWriteMode

-- |Performs the provided operation on the file. If the parent
-- directories are missing they will be created as well.
withFile :: FilePath -> ResourceMode -> (Handle -> IO r) -> IO r
withFile p r op = do
  createDirectoryIfMissing True (parentDir p)
  let mode = resourceToIOMode r
  S.withFile p mode op

parentDir :: FilePath -> FilePath
parentDir = reverse . dropWhile (/= '/') . reverse
```

Don't forget to export the helpers:

```haskell
module Site.Posts.Literate
  (
    module Diagrams.Prelude
  , module Diagrams.Backend.SVG
  , ResourceMode(..)
  , overwriteWithFile
  , withFile
  )
  where
```

And that's about it for this first iteration of the Literate module.
In the future this will be the literate prelude for other posts, so
the module will be picking up more helpers.

<h2>Running the Posts</h2>

Next we need to be able to run the posts from the `Hakyll` site.

We'll start with a module that just runs `Haskell` code.

<h3>Literate.Compile</h3>

```haskell
module Site.Posts.Literate.Compile
  (
    runghcPost
  )
  where

import System.Process.Typed
```

This calls for the `typed-process` package, so make sure to add
that to the <package>.cabal.

```
  build-depends:     base          == 4.*
                   , diagrams
                   , diagrams-lib
                   , diagrams-contrib
                   , diagrams-core
                   , diagrams-svg
                   , directory
  ----------------------------------------
                   , typed-process
```

Now let's implement the one needed method:

```haskell
-- |Runs a literate haskell post
-- using locally installed packages.
runghcPost :: FilePath -> IO ()
runghcPost f = do
  let pconf = shell ("stack runghc -- " ++ f)
  withProcess pconf checkExitCode
```

This simply runs the post as a Haskell script using our local
stack environment for installed packages.

<h3>site.hs</h3>
Finally, the site generater needs to be literate post aware.

Include the compilation package in the generator:

```haskell
import           Site.Posts.Brews.Context -- some other generator libs
import           Site.Posts.Literate.Compile
```

And add some rules for it. Previously my hakyll site only generated
html for `.markdown` files. These new posts will use the same compilation
rules as the previous `.markdown` ones, with an extra pre-process
compilation step to compile and run them.

```haskell
-- inside hakyll main
    match "posts/**/*.markdown" (blogPostRules (pure ()))

    match "posts/**/*.lhs" (blogPostRules (
      getResourceFilePath
      >>= unsafeCompiler . runghcPost))
```

here the existing rules have been factored out into a helper
function `blogPostRules :: Compiler () -> Rules ()` that accepts
a preprocess argument. Here's what that function looks like.

```haskell
blogPostRules :: Compiler () -> Rules ()
blogPostRules preProcess = do
  route (setExtension "html")
  compile (
      preProcess
      >> {- Previous blog post steps -}
```

And that's it! Now we just need to write a literate haskell markdown
post to test it out, which is conveniently the post you're reading right
now.

<h2>Trying it Out</h2>

So far all the code in the post has just been for static site generation. Now
let's write some code that'll actually be run and generate a user-visible
resource.

Since the tooling made written above is primarily for resource generation and
not for illustrative purposes, I plan on hiding much of the resource
generation code behind [`<details>` tags](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details). This allows the code to not distract from
the post, but readers still have access to it if they are curious.
Alternatively you could use multiline comments if you just want
the code completely hidden.

<details>
<summary>Collapsed Literate Code to Generate a Diagram</summary>
This is all the code to generate a small Hello World! diagram

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts  #-}
> {-# LANGUAGE TypeFamilies      #-}
>
> import Site.Posts.Literate
> import Data.List (foldr1)
>
> hello :: Diagram B
> hello = foldr1 (|||) (zipWith boxIt "Hello World!" shapes) where
>   shapes = cycle [ unitCircle # fc red
>                  , triangle 2 # fc green
>                  , square 2 # fc blue
>                  , pentagon 1.5 # fc yellow
>                  ]
>   boxIt c shape = text [c] <> shape # lw thin
>
> -- This path is picked up by my site's image rules
> outputPath = "images/posts/2019-09-14-hello-world.svg"
>
> main = renderSVG outputPath (mkWidth 500) hello

</details>

And here is the result:

![Diagrams Hello World](/images/posts/2019-09-14-hello-world.svg)

There you go, all the machinery needed to run blog posts as code
and include the output in your static site.

<h2>A Couple of Gotchas</h2>
I've bumped into a couple of small gotchas with literate haskell
in markdown. First, for whatever reason it does not like the github
flavored header synatx (##). Using this caused compilation errors
with `runghc`.

Additionally, using Haskell's application operator `(<dollar>)` in
example code fences caused html generation to fail. Haven't figured
out what the root cause of that is yet, but that just means that
some extra parentheses need to be thrown in.
