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

Dir[File.expand_path "lib/platformer/shared_dsl_configuration/**/*.rb"].each do |f|
  require_relative f
end

Dir[File.expand_path "lib/platformer/dsls/**/*.rb"].each do |f|
  require_relative f
end

require "app/platform_model"
require "app/platform_callback"
require "app/platform_service"

Dir[File.expand_path "lib/platformer/composers/**/*.rb"].each do |f|
  require_relative f
end

module Platformer
end
