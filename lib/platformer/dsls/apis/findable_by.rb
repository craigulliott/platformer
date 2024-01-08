module Platformer
  module DSLs
    module APIs
      module FindableBy
        def self.included klass
          klass.define_dsl :findable_by do
            description <<~DESCRIPTION
              Set the unique columns which can be used to find a record. Typically (and by default) this
              is the primary key. But as an example, it's common that the User record could be findable
              by their username.
            DESCRIPTION

            requires :column, :symbol, array: true do
              description <<~DESCRIPTION
                The column names which can be used to find a record.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
