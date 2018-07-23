---
title: Hands of Time Solver
---

The [`Hands of Time Solver`](https://github.com/jhmcstanton/hands-of-time-solver) is a tool to solve the frequent Hands of Time puzzles in the game _Final Fantasy XIII-2_. Checkout [this video](https://www.youtube.com/watch?v=etl6lgKN1QE) for a quick look at how the puzzles work. This was written while doing my undergrad at KU.

This was made both as a favor to my wife to help her get past her least favorite parts of the game and as a good excuse to learn Haskell library [`diagrams`](http://hackage.haskell.org/package/diagrams) and the Haskell web framework [`scotty`](http://hackage.haskell.org/package/scotty). The `diagrams` library is an eDSL to create graphical images easily in Haskell using all its nice built in features. `scotty` is a framework aimed at simplicity that is similar to the ruby framework [`sinatra`](http://sinatrarb.com/). 


When the game prompts the player with a clock that looks like this:

![](/images/hands-of-time-clock.svg)

the user can fill in the form to get a solution in this format:

![](/images/hands-of-time-solution0.svg)
