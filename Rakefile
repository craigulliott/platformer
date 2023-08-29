# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

require "byebug"
require "platformer"

import "lib/tasks/documentation.rake"

RSpec::Core::RakeTask.new(:spec)

task default: :spec
