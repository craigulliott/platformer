module Platformer
  module Databases
    class Migrations
      module Helpers
        module All
          # the base set of enhanced migrations from DynamicMigrations
          include DynamicMigrations::ActiveRecord::Migrators

          # for our additional validation templates
          include Validations::Numeric
          include Validations::TrimmedAndNullified
          include Validations::ZeroNulled
          include Validations::Case
          include Validations::StringLength

          # for our additional trigger templates
          include Triggers::Immutable
          include Triggers::TrimmedAndNullifiedArray
        end
      end
    end
  end
end
