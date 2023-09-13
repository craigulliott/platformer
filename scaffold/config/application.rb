ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Set up gems listed in the Gemfile.
require "bundler/setup"

ENV["PLATFORMER_ROOT"] ||= File.expand_path("../", __dir__)

require "platformer"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Platformer.env)

# used when generating globally unique ids for your objects, these ids are
# used within our graphql schema (global ids are required to be relay compatible)
GlobalID.app = :"name-of-your-app"

Platformer.initialize!
