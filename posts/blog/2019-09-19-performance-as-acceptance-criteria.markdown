---
title: Performance as Acceptance Criteria
---

Every software engineer has heard the most sensational part of Knuth's
famous quote about optimizations, but sometimes we do need to take a step back
and look at the full context:

> Programmers waste enormous amounts of time thinking about, or worrying about, the speed of noncritical parts of their programs, and these attempts at efficiency actually have a strong negative impact when debugging and maintenance are considered. We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%.

Time and again I've seen the most sensationalist part taken too seriously by
engineers, myself included at times, who then simply ignore performance of systems
they design and build. To be clear, the various microoptimizations
we make while coding typically do not matter. What we should consider
as engineers is the black box performance of our individual components and
the distributed systems we build with these components.

## Performance is More than Speed

Before getting started, performance needs clarification. Many engineers consider
performance to simply be the speed of their code. That's only one measurable
component that could specify performance. Performance could also be the
memory footprint of an application, like when it needs to run on client devices.
It could also be the accuracy of user-facing results. Consider performance
as a stand in for specific, definable metrics.

## Component Level Performance

A component here is a single service or artifact that is somewhat standalone.
These are applications or services that today probably already have integration
tests running against them on every build, or is possibly a core widget embedded
across multiple client facing domains that should feel snappy to the user.

Components may or may not have [real time requirements](https://en.wikipedia.org/wiki/Real-time_computing#criteria_for_real-time_computing)
to operate successfully, but most do have some unwritten performance
characteristics that must be met. This could be that the page load time must
be under 3 seconds, or that an ETL pipeline must
support enough throughput to not cause a request backlog, or that some data
must be deleted within a certain number of days to remain compliant. These
are all very real performance concerns that typically are understood, but not
always spelled out, and cause very real problems for an organization when 
performance degrades.

### Performance is a Requirement

When designing new components, ask your stakeholders and designers about
performance expectations. Shoot for as specific an answer as you can get -
whatever response you receive will need to be made into a specific measurable
metric. Whatever metric(s) you and your stakeholder agree on should be included
in the acceptance criteria of the overall deliverable. This allows engineers
to remain cognizant of performance goals and ensures that the client
has reasonable expectations.

Performance tests should be written into the component just like unit and
integration tests typically are today. [`gatling`](https://gatling.io/) and
[`jmeter`](https://jmeter.apache.org/) are both great tools for measuring
web application performance, and are typically easy to include in builds. There
are various other tools for measuring client side performance or 
[messaging throughput.](https://rabbitmq.github.io/rabbitmq-perf-test/stable/htmlsingle/)
Codify your performance requirements and use whatever tooling
fits your needs to ensure that you don't have performance degradation -
there's nothing worse than finding out that what looked great in dev
simply won't work at all with production workloads. Be as realistic as possible
when writing performance tests and fail your build when you don't hit your
criteria.

## System Level Components

Large scale systems are even more likely to have unwritten performance
requirements. Multiple asynchronous events may need to complete within a
deadline, or a system's accuracy may be beholden to scheduled batch jobs.
Performance characterics of these large scales systems are often even more
important to pin down and codify with stake holders since it will likely
specify what architectures are suitable for the design. Architecture overhauls
are expensive, time consuming, and a drain on the team, but are not uncommon
when the delivered product is simply unable to meet unwritten performance
demands.

At this level of performance analysis consider the entire system as a black box.
Identify the inputs and outputs of the system then write additional performance
tests for this holistic view (for that matter, consider writing integration
tests from the same view). It's insufficient to simply sum up component
level performance tests to determine if a system is performant enough -
infrastructure will add measurable overhead and it's easy to not sum
component metrics correctly in the face of a complex system. The better
solution is to run these tests whenever an invidual component is redeployed
to your dev/test/stage environment and catch issues early.

## TL;DR

- Get performance requirements while collecting other project requirements
- Include performance tests in your artifacts (and fail the build with them)
- Write performance tests for your systems (and raise an alarm when these fail).
