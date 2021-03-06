# jhmcstanton.github.io

My own github pages site! This site is built with [`Hakyll`](https://jaspervdj.be/hakyll/)). 

## Building

First you'll need [`Stack`](https://docs.haskellstack.org/en/stable/README/) installed to build the project:

```sh
stack build
```

The first build may take a little while since it will pull down the dependencies _and_ the correct version of `GHC`. 

Next, you'll need [`selenium 2`](http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar)
and [version 46.1 of firefox](https://ftp.mozilla.org/pub/firefox/releases/46.0.1/). These old versions are unfortunately necessary since the
[`webdriver` library](http://hackage.haskell.org/package/webdriver) only
supports `selenium` up through version 2 currently.

This is run with the following:

```sh
java -jar selenium-server-standalone-*.jar
```

It is recommended to download these to this repo's directory at
`<directory-root>/.bin/selenium.jar` and
`<directory-root>/.bin/geckodriver` (included in `.gitignore`)
to be able to use the development scripts below.

Once the binary is built and selenium is running,
the site can be generated like so:

```sh
stack exec site build
```

### Resume

Building the resume pdf requires `xelatex`.

## Development

Generally development is done in the `develop` branch. This keeps once branch that is clean and easy to use for myself and then in the `master` branch files can be moved around as needed to match the expected structure for Github Pages.

When writing posts it is also convenient to use 

```sh
[./watch](./watch)
```

to build the site as it is being written and check the output with a test server.

### Music files

Lilypond (.ly) requires lilypond to be insalled locally.

## Deployment

Deployment is straightforward - `master` just needs to have an `index.html` in the root and the generated posts need to be moved from the target directory, [`_site`](./site), and into the expected relative paths.

The `Hakyll` developers conveniently have a script available in their docs site, which I gladly borrowed: [`deploy.sh`](./deploy.sh). Just running this script will get `master` up to date with the generated html in the correct directories. 
