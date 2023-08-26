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

  spec.files = ["README.md", "LICENSE.txt", "CHANGELOG.md", "CODE_OF_CONDUCT.md"] + Dir["lib/**/*"]

  spec.require_paths = ["lib"]

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

  # state machines
  spec.add_dependency "aasm", "~> 5.5"

  # postgres and postgis
  spec.add_dependency "pg", "~> 1.5"
  spec.add_dependency "activerecord-postgis-adapter", "~> 8.0"

  # orm (ActiveRecord)
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "activemodel", "~> 7.0"
  spec.add_dependency "activerecord", "~> 7.0"

  # spec helpers (development only)
  spec.add_development_dependency "pg_spec_helper", "~> 1.4"
  spec.add_development_dependency "class_spec_helper", "~> 1.0"
end
