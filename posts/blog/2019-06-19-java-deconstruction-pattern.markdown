---
title: Proposed Java Deconstruction Pattern Syntax is Weird 
---

Well, its not _officially_ proposed, yet. As part of Project Amber
the Java team is working on implementing 
[_Pattern Matching_](https://en.wikipedia.org/wiki/Pattern_matching) 
([here's the proposal](https://cr.openjdk.java.net/~briangoetz/amber/pattern-match.html)).
This would be awesome! For those unfamiliar with it, a cheesy way to
describe them is that they are a form of super switch statement that
supports arbitrary deconstruction and comparisons on complex types, 
not just primitives.

Languages with Algebraic Data Types frequently have this feature, some
examples in Haskell:

```haskell
-- Pattern matching works on numbers

factorial 0 = 1
factorial n = n * factorial (n - 1)


-- Simple data type representing possible failure / absence
-- of a result
data Maybe a = Just a | Nothing

simplePattern (Just something) = putStrLn something
simplePattern Nothing          = putStrLn "Nothing here!"

-- Arbitrarily nested match across multiple data types
complexPattern :: Maybe (Maybe (Maybe String)) -> String
complexPattern m = 
  case m of
    Nothing                      -> "Outermost is Empty!"
    Just Nothing                 -> "Middle is Empty!"
    Just (Just Nothing)          -> "Innermost is Empty!"
    Just (Just (Just "YO"))      -> "Hey back at ya!"
    Just (Just (Just something)) -> something
```

Pattern matching allows interesting interrogation of data that
can make control flow more obvious and clean. This feature works
well in languages supporting Algebraic Data Types since ADTs are
mostly "dumb" containers.

Java, along with most languages, would definitely benefit from this
feature. Java programmers are already accustomed to "dumb" containers,
POJOs, and we could make heavy use of pattern matching with those.

## Deconstruction Patterns

Languages with Algebraic Data Types and pattern matching support
deconstructing the data out of the box, no programmer intervention
required. That's not the only approach to pattern matching though,
the language could put the deconstruction in the hands of the programmer.

The latter approach _appears_ to be on the table for Java's inclusion
of pattern matching. I say "appears" because I actually ran into this
syntax in a [somewhat unrelated post](http://cr.openjdk.java.net/~briangoetz/amber/serialization.html#sidebar-pattern-matching) 
about the future of Java serialization by Brian Goetz. This feature
isn't available in any JDK build that I could find, and isn't slated
for any immediately upcoming Java releases, so this post is _absolutely_
jumping the gun. Sorry about that..

Anyway, to borrow straight from the post, the syntax for defining 
patterns for a type _may_ look like this:

```java
public class Point {
    private final int x;
    private final int y;
    
    // Constructor
    public Point(int x, int y) { 
        this.x = x;
        this.y = y;
    }

    // Deconstruction pattern
    public pattern Point(int x, int y) { 
        x = this.x;
        y = this.y;
    }
}
```

This may be matched like so (still from Goetz's post):

```java
if (o instanceof Point(var xVal, yVal)) {
    // can use xVal, yVal here
}
```

This is _super weird_. Allowing the programmer to define the
deconstruction pattern is a great idea, but this proposed syntax for
pattern declaration runs pretty against how Java typically works. Let's
take another look:

```java
    // Deconstruction pattern
    public pattern Point(int x, int y) { 
        x = this.x;
        y = this.y;
    }
```

### Method Signature

This construct looks like another type of constructor, which I suppose
makes sense since its related to the structure of the data. The
_pattern_ in the signature must be a new proposed keyword, which
is fine, but when quickly skimming through it almost looks like a return
type. All of this is fine, just extra syntactic machinery to support
the feature, just not what I would expect.

### Arguments as Variables

Goetz calls this a "reverse constructor" which allows the class to
assign to a list of output parameters _which are defined as the
argument list_. _That_ is the main weird thing here.

Arguments in Java are passed by value, including object references.
The deconstruction pattern here 

## Related Approaches

Scala supports both types of pattern matching.
[Case classes](https://docs.scala-lang.org/tour/case-classes.html)
provide the language handled deconstruction of patterns, and are the
typical pattern matching mechanism. For more complex types the language
supports [_Extractor Objects_](https://docs.scala-lang.org/tour/extractor-objects.html),
which is a fancy way of saying that the programmer defines a function
that does the extraction, then the language will allow the type to be
used in `match` expressions.


```scala
class Point(val x: Int, val y: Int) { }

object Point {
  // deconstruction pattern / extractor
  def unapply(p : Point) : Option[(Int, Int)] = Some((p.x, p.y))
}

//
// Repl
//
scala> val p = new Point(1, 2)
p: Point = Point@121cf6f4

scala> p match {
     |   case Point(x, y) => System.out.println("YO! X: " + x + " y: " + y)
     | }
YO! X: 1 y: 2
```

The above example defines a class with the related magic `unapply` method
for decomposing it. This allows the programmer extra flexibility
to define what a pattern on their type looks like. Another silly
example would be a `Range` type that only matches if the high value
is at least as large as the low value.

```scala

```
