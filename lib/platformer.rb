# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require "dsl_compose"
require "dynamic_migrations"
require "active_record"

require "platformer/version"

require "platformer/databases"
require "platformer/databases/postgres/server"
require "platformer/databases/postgres/server/database"
require "platformer/databases/configuration"

require "platformer/class_map"

require "platformer/documentation"
require "platformer/documentation/markdown"
require "platformer/documentation/arguments_documenter"
require "platformer/documentation/composer_class_documenter"
require "platformer/documentation/dsl_documenter"
require "platformer/documentation/dsl_method_documenter"

Dir[File.expand_path "lib/platformer/shared_dsl_configuration/**/*.rb"].each do |f|
  require_relative f
end

Dir[File.expand_path "lib/platformer/dsls/**/*.rb"].each do |f|
  require_relative f
end

Dir[File.expand_path "lib/platformer/dsl_readers/**/*.rb"].each do |f|
  require_relative f
end

require "app/platform_base"
require "app/platform_model"
require "app/platform_callback"
require "app/platform_service"

Dir[File.expand_path "lib/platformer/composers/**/*.rb"].each do |f|
  require_relative f
end

module Platformer
end
