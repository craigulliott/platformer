# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("Gemfile", __dir__)

# Set up gems listed in the Gemfile.
require "bundler/setup"

ENV["PLATFORMER_ROOT"] ||= File.expand_path(".", __dir__)

require "platformer"

Platformer.initialize!

require "bundler/gem_tasks"
require "rspec/core/rake_task"

import "lib/tasks/documentation.rake"

RSpec::Core::RakeTask.new(:spec)

task default: :spec
