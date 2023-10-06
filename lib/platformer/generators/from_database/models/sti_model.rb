module Platformer
  module Generators
    module FromDatabase
      module Models
        warn "not tested"
        class StiModel < PlatformFile
          def initialize table, sti_name
            super :model, table.schema.name, table.name, sti_name
          end
        end
      end
    end
  end
end
