def recursive_require_relative path
  Dir[File.expand_path("#{path}/**/*.rb", __dir__)].each do |f|
    require_relative f
  end
end

require_relative "databases"

require_relative "postgres/functions/function"
recursive_require_relative "postgres/functions"

require_relative "postgres/server"
recursive_require_relative "postgres/server/database/composers"
require_relative "postgres/server/database"

require_relative "configuration"
require_relative "migrations"
require_relative "migrations/migration_file"
require_relative "migrations/current"
require_relative "migrations/current/loader"
