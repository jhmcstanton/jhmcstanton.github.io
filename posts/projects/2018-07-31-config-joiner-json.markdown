---
title: 'config-joiner-json: A Configuration Aid'
---

The other day I decided to work on a little helper aid and library for dealing
with many configuration files - [`config-joiner-json`](https://github.com/jhmcstanton/config-joiner-json) is the result of that quick work.

# Why 

Projects frequently end up with multiple configuration files for various scenarios
or environments, and in my case this frequently is in JSON. Being programmers, most
of the project will be configurable and these configuration files end up with a lot
of overlapping and redundant configuration that ends up being noise compared to the
scenario or environment specific configuration that forced us to create the new 
config file in the first place. 

`config-joiner-json` aims to fix this redundant config. This tool allows the user
to factor out common config from their JSON files into one `common.json`, `parent.json`,
 or `whatever.json`, and then only the config that is actually unique lives in the
 more specific configuration files: `config1.json`, `dev.json`. Whenever changes
 are made to any of the configuration the user simply runs `config-joiner-json` to 
 regenerate the completed JSON files and then drops them wherever they are needed. As an added bonus this also means that the configuration files used everywhere are machine
 generated and thus less error-prone from someone missing a comma.
 
# How
 
 `config-joiner-json` is built in `Haskell` primarily using [`aeson`](http://hackage.haskell.org/package/aeson-1.4.0.0/docs/Data-Aeson.html) for the JSON handling. 
 
 `config-joiner-json` is both the binary outlined above and a library. The library 
 houses all of the JSON reading, parsing, joining, writing, and even includes
 a handy `joinMain` method to wrap it all up. The binary basically combines `joinMain`
 with some option parsing, courtesy of [`optparse-applicative`](http://hackage.haskell.org/package/optparse-applicative), with some file system discovery.
 
 For more details on how to use the library, and general documentation, check out the repo.
 
# Spooky Types

Peeking into the [`Config.JSON.Types`](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/Types.hs) module
you might see a couple of odd things. The first that might jump out (from the link
above) is the use of [empty data declarations](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/Types.hs#L55). This is
creating a new data type without any constructor - there isn't a way to actually
have an instance of a `PreProcess` or a `PostProcess`. The other that may jump out
out the keen observer is this [`EnvConfig`](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/Types.hs#L44) data
type that is parameterized on some `a`, but that `a` is nowhere present in the 
body of the type. What's going on exactly?

This is a simple use case of a [`phantom type`](https://wiki.haskell.org/Phantom_type). 
A phantom type is just a spooky term for a type parameter that appears in the type 
constructor, but does not concretely exist on that data type. 

## Why Though

Phantom types are used somewhat frequently in Haskell (at least blog posts would
lead me to believe that) as way to tag additional information on a type to get a 
little extra help from the compiler. In `config-joiner-json` they are specifically
used to tag `EnvConfigs` with their status - `Pre` or `Post` processing or joining. 
The [`Config.JSON.IO` module](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/IO.hs) uses these types to indicate
that the bytes returned [haven't been processed yet](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/IO.hs#L34) 
or [have been processed](https://github.com/jhmcstanton/config-joiner-json/blob/69361e4bfd47fc16a74306d811841658e5c095c2/lib/Config/JSON/IO.hs#L56) and are ready for disk. 

In this library these serve primarily as user documentation and a little extra type
safety, but a library writer that religiously hid constructors could easily enforce
that data passed to library functions is only ever in very specific states.

## Elsewhere

Haskell isn't the only language with support for phantom types - many languages with
generics can use this trick. Here's a [post where the writer uses them in Java](http://gabrielsw.blogspot.com/2012/09/phantom-types-in-java.html), and it follows very much
the same pattern as used here. 
