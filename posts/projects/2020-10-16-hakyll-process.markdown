---
title: Announcing hakyll-process
---

Today I am excited to announce [`hakyll-process`](https://hackage.haskell.org/package/hakyll-process-0.0.2.0).
This is a tiny library aimed at making it easier to call out to other tools on your machine for generating
files to be deployed to your static site. This is useful when there are no Haskell bindings to the tool or
libraries for handling the input file type.

Currently I am using this in my own site to regenerate a current resume with `xelatex` and creating music images
from lilypond files. Hopefully this is useful for other hakyll users out there!
