---
title: Literate Markdown to Literate HTML
---

In my [previous post](./2019-09-14-literate-markdown-with-diagrams.html)
I described a Hakyll site extension that allows a blog author to treat
their raw markdown files as Haskell code for the purposes of generating
site resources. It's much more common for Haskell bloggers to make
literate Haskell blog posts for the purposes of distributing runnable
example code to readers. In this post we'll make a small tweak so that
our final browser-rendered result is literate haskell friendly for readers
as well.

<h2>Updating the Code Renderer</h2>

Only a couple of small tweaks are needed since we were previously rendering
our markdown via [`pandoc`](http://hackage.haskell.org/package/pandoc).

First, we need to make a `pandoc` an explicit dependency on our site
generator. This is needed because `hakyll` does not reexport the necessary
`pandoc` [extensions](http://hackage.haskell.org/package/pandoc-2.7.3/docs/Text-Pandoc-Extensions.html)
and [options](http://hackage.haskell.org/package/pandoc-2.7.3/docs/Text-Pandoc-Options.html)
modules.

```
  build-depends:    base          == 4.*
                  , hakyll        == 4.12.*
  -----------------------------------------------
                  , pandoc
```

Next we'll tweak the renderer to enable the literate Haskell `pandoc` extension.

```haskell
...
import           Text.Pandoc.Extensions
import           Text.Pandoc.Options
...

-- Tweaking the Hakyll defaults to include
-- enabling literate haskell
myWriterOptions :: WriterOptions
myWriterOptions =
  let exts = writerExtensions defaultHakyllWriterOptions in
  defaultHakyllWriterOptions {
    writerExtensions = enableExtension Ext_literate_haskell exts
  }

-- A helper custom pandoc renderer so we don't have to lug
-- around our custom options
myRenderPandoc :: Item String -> Compiler (Item String)
myRenderPandoc = renderPandocWith defaultHakyllReaderOptions myWriterOptions

-- Update our blog post rules to use the custom compiler
blogPostRules :: Compiler () -> Rules ()
blogPostRules preProcess = do
  route (setExtension "html")
  compile (
      preProcess -- runs the markdown as code
      >> getResourceString
      >>= applyAsTemplate postCtx
      >>= myRenderPandoc -- renders the post with bird (>) syntax
      >>= loadAndApplyTemplate "templates/post.html"    postCtx
      >>= loadAndApplyTemplate "templates/default.html" postCtx
      >>= relativizeUrls )
```
Note, I have some extra stuff in there for some of my other blog posts
(and elided some of the really unnecessary stuff), all you should
need to do is include your `myRenderPandoc` that uses your custom
`WriterOptions` then `hakyll` and `pandoc` will happily render
your HTML in a literate haskell friendly manner.

This post uses this new renderer. When `hakyll` builds it will
run the following code:

```haskell

> main = putStrLn "yo"

```

and you, dear reader, can copy-and-paste this file from your browser,
save it as a `.lhs` file and run it with `runghc`.

That's about it! Just enable that one `pandoc` extension then you and
your readers can run code together.


