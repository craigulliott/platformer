# frozen_string_literal: true

def recursive_require_relative path
  Dir[File.expand_path("#{path}/**/*.rb", __dir__)].each do |f|
    require_relative f
  end
end

#
# composers, added in the required order
#

# ActiveRecord
require_relative "active_record/create_active_models"
recursive_require_relative "active_record"

# Presenters
require_relative "presenters/create_presenters"
recursive_require_relative "presenters"

# GraphQL
require_relative "graphql/schema/create_types"
recursive_require_relative "graphql"

# Migrations
require_relative "migrations/create_structure"
require_relative "migrations/primary_key"
recursive_require_relative "migrations/columns"
recursive_require_relative "migrations/indexes"
recursive_require_relative "migrations/associations"

# the rest can be required in any order (and it's safe to require files twice)
recursive_require_relative "."
