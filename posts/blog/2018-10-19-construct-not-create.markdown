---
title: Construct not Create
---

Today in Java it is pretty common practice to provide all dependencies for an object in its constructor. 
This encourages modular and testable code, and is pretty universally accepted.

```java

public MyClass1(final MyDep1 dep1, final MyDep2 dep2) {
  this.dep1 = dep1;
  this.dep2 = dep2;
}
```

The dependency injection here encourages the class to write towards interface and not depend on a concrete
interface. Again, universally accepted, nothing surprising here.

There are other types of dependencies as well, typically runtime configuration dependencies. These will often
be represented as a `Properties` instance or other type of Configuration abstraction, usually with a `Map`
structure or interface to them. Frequently projects and libraries will provide the `Configuration` instance
as a dependency to their classes.

```java
public MyClass2(final somePackage.Configuration conf) {
  this.serviceUrl = conf.getString("serviceUrl");
  this.someInteger = conf.getInt("someInteger");
}
```

One could argue that this is dependency injection since the `Configuration` is provided by the caller.
Really, though, this is injecting an implicit dependency, the `Configuration`, and not the actual dependencies,
the URL and integer that are required. 

This is a relatively small difference and, honestly, may not matter much overall but it comes up fairly frequently
and is a bit a of pet peeve of mine. A quick breakdown of what irks me here:

### Incorrect Injection

Again, we aren't actually providing dependencies, we are deriving them from a big blob of `Configuration` This 
is opaque to the caller unless all the used keys are properly documented (and that doc is maintained).

### Not as Modular

This immediately makes the class less modular since it is now depending on something it doesn't even directly
use. 

More subtly, the class now has access to things it shouldn't need to know about. Providing all of the config,
while convenient, exposes all of the configuration to every class that has a `Configuration` plumbed to it, 
potentially leaking abstractions.

### Additional Logic

Ideally our constructors are as _dumb as possible_. By that I mean they either directly assign values if able or,
at the most, checks that arguments are in a legal state. 

All the additional logic requires extra testing which gets tedious and, occasionally, error prone. Tests need
to handle cases when the `Configuration` provided is missing some fields as well as the expected case of 
values being illegal (null `Strings`, negative `ints`, etc).

Providing a method to create an object from a dependency like `Configuration` above is totally valid, but should
be it's own method. This pattern is typically called the `static factory method` pattern in Java and, happily, also
co mes up in many projects. 


## Separate the Logic

```java
// public here, but frequently this is private
public MyClass2(final String someUrl, final int someInteger) {
  this.serviceUrl = someUrl;
  this.someInteger = someInteger;
}

// Frequently called create
public static MyClass2 fromConf(final somePackage.Configuration conf) {
  final String someUrl = conf.getString("serviceUrl");
  final int someInteger = conf.getInt("someInteger");

  return new MyClass2(someUrl, someInteger);
}
```

Note here that all that `Configuration` logic is moved out into its own static place, still allowing callers
the convenience of just passing the configuration. Somewhat frequently I've seen the constructor made `private`
once these factory methods are implemented. Personally, I keep them public for testing and to avoid imposing
that the caller uses a specific `Configuration`, but each has its use case.

## Environment Variables

Sometimes constructors will use values from the system environment to populate fields:

```java
public MyClass3(/** Look, no dependencies ma! */) {
  this.serviceUrl = System.getProperty("serviceUrl");
  this.anotherUrl = System.getProperty("anotherUrl");
}
```

Again, this is another case where this constructor should take its dependencies as arguments and provide
a static factory method. This particular case bugs me even more since its not even apparent that the object
requires any properties at all. Definitely avoid this case as well.


## KISS

This is just a case of keeping things simple. Sometimes when these things come up in code it seems like Java
is politely giving the programmer a little _too_ much rope and we, as nice programmers, provide an abstraction
in the wrong place. Remember, constructors are for simple assignments and not for creating the object through
derivation.

`Scala` (accidentally?) has an interesting solution to things like this. The parameters on the primary constructor
are fields on the object, so assignment is handled just by having a primary constructor. This, at least for me, 
removes some of the temptation to have constructors include logic to populate fields. That being said, the 
body of the class is also part of the primary constructor, so if extra logic is _really_ needed, it is 
supported, although it looks a little odd. Check out this [_O'Reilly'_ Scala cookbook](https://www.oreilly.com/library/view/scala-cookbook/9781449340292/ch04s02.html) for details and examples.
