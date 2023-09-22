require_relative "databases"

require_relative "postgres/functions/function"
Platformer.recursive_require_relative "postgres/functions", __dir__

require_relative "postgres/server"
Platformer.recursive_require_relative "postgres/server/database/composers", __dir__
require_relative "postgres/server/database"

require_relative "configuration"
require_relative "migrations"
require_relative "migrations/migration_file"
require_relative "migrations/current"
require_relative "migrations/current/loader"

Platformer.recursive_require_relative "migrations/helpers/triggers", __dir__
Platformer.recursive_require_relative "migrations/helpers/validations", __dir__
require_relative "migrations/helpers/all"

Platformer.recursive_require_relative "migrations/templates", __dir__

require_relative "migration"
