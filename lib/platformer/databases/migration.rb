module Platformer
  module Databases
    class Migration < ::ActiveRecord::Migration[7.0]
      include DynamicMigrations::ActiveRecord::Migrators
      include Platformer::Databases::Migrations::Helpers::All
    end
  end
end
