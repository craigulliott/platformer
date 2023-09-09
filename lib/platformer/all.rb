require_relative "version"

require_relative "environment"
require_relative "root"
require_relative "load_tasks"

require_relative "server/server"

require_relative "databases/all"

require_relative "constants/all"

require_relative "class_map"

require_relative "documentation/all"

require_relative "shared_dsl_configuration/all"

require_relative "dsls/all"

require_relative "dsl_readers/all"

# The base composer classes
# These classes contain all the platformer DSL's, and everything in a
# platformer projects app folder inherits from these classes
require_relative "platform_base/all"

require_relative "parsers/all"

require_relative "services/all"
