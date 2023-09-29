require_relative "boot"

# used when generating globally unique ids for your objects, these ids are
# used within our graphql schema (global ids are required to be relay compatible)
GlobalID.app = :"name-of-your-app"

# require all our platform definition files
Platformer.recursive_require_relative "../platform", __dir__

# dynamically compose the platform (runs all the composers and builds the graphql server)
Platformer.initialize!
