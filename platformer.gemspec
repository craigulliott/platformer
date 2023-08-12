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

  spec.add_dependency "dsl_compose", "~> 2.2"
  spec.add_dependency "dynamic_migrations", "~> 3.0"

  spec.add_dependency "pg", "~> 1.5"
  spec.add_dependency "activerecord-postgis-adapter", "~> 8.0"

  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "activemodel", "~> 7.0"
  spec.add_dependency "activerecord", "~> 7.0"

  spec.add_development_dependency "pg_spec_helper", "~> 1.4"
  spec.add_development_dependency "class_spec_helper", "~> 1.0"
end
