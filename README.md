# jhmcstanton.github.io

My own github pages site! This site is built with [`Hakyll`](https://jaspervdj.be/hakyll/)). 

## Building

First you'll need [`Stack`](https://docs.haskellstack.org/en/stable/README/) installed to build the project:

````sh
stack install 
```

The first build may take a little while since it will pull down the dependencies _and_ the correct version of `GHC`. 

Once built, the site can be generated like so:

```sh
stack exec site build
```

## Development

Generally development is done in the `develop` branch. This keeps once branch that is clean and easy to use for myself and then in the `master` branch files can be moved around as needed to match the expected structure for Github Pages.

When writing posts it is also convenient to use 

```sh
stack exec site watch
```

to build the site as it is being written and check the output with a test server.

## Deployment

Deployment is straightforward - `master` just needs to have an `index.html` in the root and the generated posts need to be moved from the target directory, [`_site`](./site), and into the expected relative paths.

The `Hakyll` developers conveniently have a script available in their docs site, which I gladly borrowed: [`deploy.sh`](./deploy.sh). Just running this script will get `master` up to date with the generated html in the correct directories. 
