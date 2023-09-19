---
layout: default
title: Suppress Namespace
parent: Models
has_children: false
has_toc: false
permalink: /models/suppress_namespace
---

Altering the default behavior to exclude a model's namespace from
its GraphQL type name can be beneficial. This is particularly useful
for ubiquitous nodes that are unlikely to conflict with other types
  as the system evolves. Doing so can also eliminate redundancy and
  improve clarity. For instance, models like `User` and `Organization`
  don't require namespacing, as the types `users_user` and
  `organizations_organization` would be unnecessarily verbose and
  unexpected. Exercise caution when using this feature, however, since even highly specific models may clash with new additions in the long-term development of the system.

```ruby
class MyModel < PlatformerModel
  suppress_namespace 
end
```