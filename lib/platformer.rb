# frozen_string_literal: true

require "dsl_compose"
require "active_record"

require "platformer/version"

Dir[File.expand_path "lib/platformer/dsls/**/*.rb"].each do |f|
  require_relative f
end

Dir[File.expand_path "app/**/*.rb"].each do |f|
  require_relative f
end

require "platformer/composer"

Dir[File.expand_path "lib/platformer/composers/**/*.rb"].each do |f|
  require_relative f
end

module Platformer
  class Error < StandardError
  end
end
