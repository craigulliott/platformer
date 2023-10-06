# frozen_string_literal: true

require_relative "sti_class_uncomposable_error"

#
# composers, added in the required order
#

# ActiveRecord
require_relative "active_record/create_active_models"
Platformer.recursive_require_relative "active_record", __dir__

# Presenters
require_relative "presenters/create_presenters"
Platformer.recursive_require_relative "presenters", __dir__

# GraphQL
require_relative "graphql/schema/create_types"
Platformer.recursive_require_relative "graphql/schema", __dir__
Platformer.recursive_require_relative "graphql/mutations", __dir__

# Migrations
#
# create all the columns first
require_relative "migrations/create_structure"
require_relative "migrations/primary_key"
Platformer.recursive_require_relative "migrations/columns", __dir__
require_relative "migrations/associations/belongs_to/create_column"
require_relative "migrations/associations/has_one/create_column"
require_relative "migrations/associations/has_many/create_column"
# now that all the columns have been created, run the rest of the composers
Platformer.recursive_require_relative "migrations/primary_key", __dir__
Platformer.recursive_require_relative "migrations/indexes", __dir__
Platformer.recursive_require_relative "migrations/associations", __dir__

# the rest can be required in any order (and it's safe to require files twice)
Platformer.recursive_require_relative ".", __dir__
