---
title: Announcing hakyll-typescript
---

Today I'm announcing version 0.0.1.0 of
[`hakyll-typescript`](http://hackage.haskell.org/package/hakyll-typescript).
`hakyll-typescript` is a small utility library for
[`hakyll`](http://hackage.haskell.org/package/hakyll) projects to support
compilation of typescript source files and minification of javascript source
or generated files.

## Usage

Like many other `hakyll` related projects, the goal with `hakyll-typescript`
is to be able to just drop the compiler into your site rules:


```haskell
import Hakyll.Typescript.TS

main = hakyll (do
  -- Matches any file inside a the directory ./scripts
  match "scripts/**" (do
    route   (setExtension "js")
    -- compiles all typescript and javascript to the js target
    -- then compresses the result
    compile compressJtsCompiler))
```

Check out the docs for other exported compilers.

### Auxiliary Uses

Using the `*jts*` family of typescript compilers, modern javascript features
that are supported by the typescript compiler but not necessarily
[`hjsmin`](http://hackage.haskell.org/package/hjsmin) can be used. This works
by compiling your source, whether typescript or just javascript, to an older
version of ecmascript that `hjsmin` already supports.
