---
title: "Monolith or Microservices?"
subtitle: "Are microservices perfect?"
date: 2023-03-05T13:00:44-08:00
draft: false
series:
- samyak
categories:
- concepts
featuredImage: "images/monolith.jpg"
featuredImageCaption: "Photo by <a href=https://unsplash.com/ko/@diesektion?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText>Robert Anasch</a> on <a href=https://unsplash.com/photos/SPHz3KKquKk?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText>Unsplash</a>"
---

The phrase _microservices_ is known to everyone, even to someone uninitiated in software engineering, but what do microservices actually mean, and why are they suddenly in such demand? Let's delve deeper.

# Microservices

* Microservices divide software components into different, loosely coupled, individually deployable, and runnable services. Since the ownership of individual services can be divided amongst other teams, these services are also split into different version-controlled repositories.
* With the growth and adoption of REST API and frameworks that support creating a service based on REST API like [Spring boot](https://spring.io), [Gin](https://github.com/gin-gonic/gin), [Flask](https://flask.palletsprojects.com/en/2.2.x/), [Ruby on Rails](https://rubyonrails.org), etc., it has become much easier to develop microservices at rapid speeds.
* Microservices make following [Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law) easier, states organizations design systems that mirror their communication structure.

# Monoliths

For the longest time, we have been using Monoliths to develop software. The monolith is commonly part of a single repository that can be run and deployed. A monolith holds all the software modules into one parent module. As the monolith grows, the modules in the monolith can have their ownership divided amongst teams.

# Pros and Cons

## Monoliths

### Pros

1. Cross-cutting changes are easier to make and test.
2. Complete software can be tested and released all at once.
3. No network latencies amongst modules since every module can be method/function calls.

### Cons

1. With time, as monolith grows, the size of monolith deployment also increases, making deployments take much longer. This problem can be alleviated to an extent by dividing modules into services and libraries, but that also makes the deployment pipeline complex.
2. Code reviews in a cross-cutting change in a monolith become more challenging to review as the monolith grows.
3. Monolith requires a lot of dedicated tooling like:
    1. Modularized CI pipeline. Suppose there is a slight change in a specific module. In that case, the whole monolith must be built and run to test changes, which causes the CI feedback loop to be longer and makes development more complicated. The CI pipeline needs to be intelligent enough to detect modules with code changes and build only the specific modules.
    2. Bugs can be introduced quickly because of cross-cutting changes.
    3. Monitoring and alerting solutions for a monolith are complicated since the monolith is an entire system owned by the organization.
4. Monoliths can make it difficult for new engineers to get onboarded, as it takes time to understand the system.

## Microservices

### Pros

1. Microservices are individually runnable and deployable, and therefore it is much easier to create and maintain their CI/CD pipelines
2. The team which owns the service can dictate the deployment cadence of microservices.
3. Monitoring and alerting of the microservices are simplified because of independent units.

### Cons

1. As the number of microservices grows, handling authentication and authorization across all services can become complicated.
2. The performance of features spanning multiple microservices can be hampered by network latency.
3. Testing patterns for microservices can become complicated because a change in microservice API can break flows that depend on the changed microservice.
4. Since microservices are independently deployable services, they can DoS one another.
5. The organization needs to define when it is reasonable to create a new microservice or when to add a functionality to an existing microservice.
6. Microservices can be expensive as each microservice can have its tech stack with its infrastructure.

# So, who wins?

Short answer; it depends.

Long answer; there is no right or wrong solution here. There's a case to make for each implementation. Recently, there have been a lot of discussions regarding [how monoliths will be the future](https://changelog.com/posts/monoliths-are-the-future). Although they are known to be challenging to scale, there are solutions like [Google's Service Weaver](https://opensource.googleblog.com/2023/03/introducing-service-weaver-framework-for-writing-distributed-applications.html) that can help to scale monoliths.
On the other hand, design patterns like [service templates](https://microservices.io/patterns/service-template.html), [app of apps deployment patterns](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/), and tools like [service mesh](https://istio.io/latest/about/service-mesh/) make scaling a fleet of microservices a lot easier.

Although there is a middle ground, [_macro-services_](http://highscalability.com/blog/2020/4/8/one-team-at-uber-is-moving-from-microservices-to-macroservic.html). A macro-service contains modules that can be tightly coupled within the whole macro-service  (modules and service) and is deployable as a single package which reduces the complexity that comes with the increased number of microservices since a macro-service can be big enough to handle complex features within itself and is small enough that the issues of a monolith do not creep in. 
