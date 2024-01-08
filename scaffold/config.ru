# This file is used by Rack-based servers to start the application.

require_relative "config/application"

# Clean up database connections after every request
# todo - determine if we really need this
# use OTR::ActiveRecord::ConnectionManagement

# Enable ActiveRecord's QueryCache for every request
# todo - determine if we really need this
# use OTR::ActiveRecord::QueryCache

run Platformer::Server::Root
