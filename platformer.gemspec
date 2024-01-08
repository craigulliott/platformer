# frozen_string_literal: true

require_relative "lib/platformer/version"

Gem::Specification.new do |spec|
  spec.name = "platformer"
  spec.version = Platformer::VERSION
  spec.authors = ["Craig Ulliott"]
  spec.email = ["craigulliott@gmail.com"]

  spec.summary = "Create SaaS Platforms through configuration"
  spec.description = "Easily create highly scalable and performant SaaS platforms through configuration"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.4"

  spec.metadata["source_code_uri"] = "https://github.com/craigulliott/platformer/"
  spec.metadata["changelog_uri"] = "https://github.com/craigulliott/platformer/blob/main/CHANGELOG.md"

  spec_files = [
    "README.md",
    "LICENSE.txt",
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "bin/platformer"
  ]
  spec_files += Dir["lib/**/*"]
  spec_files += Dir["scaffold/**/*"]

  spec.files = spec_files

  spec.require_paths = ["lib"]

  spec.bindir = "bin"
  spec.executables << "platformer"

  # for defining, validating and parsing complex DSL's
  spec.add_dependency "dsl_compose", "~> 2.2"
  # for expressing database structure via configuration and then generating
  # migrations based on the difference between what is configured and the
  # actual current state of the database
  spec.add_dependency "dynamic_migrations", "~> 3.0"

  # currency codes, money related functions, formatting and currency conversion
  spec.add_dependency "money", "~> 6.16"
  # iso country codes and names (also provides international dialing codes)
  spec.add_dependency "countries", "~> 5.6"
  # phone number formatting and sanitization
  spec.add_dependency "phony", "~> 2.20"
  # language ISO codes
  spec.add_dependency "iso-639", "~> 0.3"

  # graphql
  spec.add_dependency "graphql", "~> 2.0"

  # logging
  spec.add_dependency "logging", "~> 2.3"

  # grape is an opinionated framework for creating REST-like APIs in Ruby
  spec.add_dependency "grape", "~> 2.0"
  # we run grape on rack
  spec.add_dependency "rack", "~> 3.0"

  # We use the JSONAPI standard for rest APIs
  spec.add_dependency "jsonapi-serializers", "~> 1.0.1"

  # state machines
  spec.add_dependency "aasm", "~> 5.5"

  # postgres and postgis
  spec.add_dependency "pg", "~> 1.5"
  spec.add_dependency "activerecord-postgis-adapter", "~> 8.0"

  # redis is a fast in-memory key-value store commonly used for caching
  spec.add_dependency "redis", "~> 5.0"

  # orm (ActiveRecord)
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "activemodel", "~> 7.0"
  spec.add_dependency "activerecord", "~> 7.0"

  # "off the rails" tool for managing the database connection pool
  # todo - determine if we really need this
  # spec.add_dependency "otr-activerecord", "~> 2.2"

  # rails GlobalID provides a unique ID for every object, and ability to easily load
  # objects based on these IDs. We use it in conjunction with GraphQL to make our server
  # relay compatible
  spec.add_dependency "globalid", "~> 1.2"

  # spec helpers (development only)
  spec.add_development_dependency "pg_spec_helper", "~> 1.4"
  spec.add_development_dependency "class_spec_helper", "~> 1.0"
  spec.add_development_dependency "timecop", "~> 0.9"
end
