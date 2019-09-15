---
title: ""
---
<details><summary></summary>

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts  #-}
> {-# LANGUAGE TypeFamilies      #-}
>
> import Site.Posts.Literate
>
> fourzerofour :: Diagram B
> fourzerofour = center $ text "404"
>                # fontSize 250
>                # fc grey
>                # lighter
>                # font "freeserif"
>                <> strutY 0.5 <> strutX 1
>
> outputPath = "images/404.svg"
>
> main = renderSVG outputPath (mkWidth 500) fourzerofour

</details>

<img src="/images/404.svg" style="margin: auto; width: 100%"></img>

Woops, looks like that page doesn't exist.
