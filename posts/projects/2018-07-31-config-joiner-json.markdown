---
title: 'config-joiner-json: A Configuration Aid'
---

The other day I decided to work on a little helper aid and library for dealing
with many configuration files - [`config-joiner-json`](https://github.com/jhmcstanton/config-joiner-json) is the result of that quick work.

## Why 

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
 
## How
 
 `config-joiner-json` is built in `Haskell` primarily using [`aeson`](http://hackage.haskell.org/package/aeson-1.4.0.0/docs/Data-Aeson.html) for the JSON handling. 
 
 `config-joiner-json` is both the binary outlined above and a library. The library 
 houses the all of the JSON reading, parsing, joining, writing, and even includes
 a handy `joinMain` method to wrap it all up. The binary basically combines `joinMain`
 with some option parsing, courtesy of [`optparse-applicative`](http://hackage.haskell.org/package/optparse-applicative), with some file system discovery.
 
 For more details on how to use the library, and general documentation, check out the repo.
 

