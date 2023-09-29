ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Set up gems listed in the Gemfile.
require "bundler/setup"

ENV["PLATFORMER_ROOT"] ||= File.expand_path("../", __dir__)

require "platformer"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Platformer.env)
