module Platformer
  module DSLs
    module Models
      module Positionable
        def self.included klass
          klass.define_dsl :positionable do
            description <<~DESCRIPTION
              Adds functionality to your model which allows manual sorting of records.

              A required integer column named 'position' will be added to your model, and
              constraints and stored procedures will be used to ensure ensures that the
              `position` values remain consistent and sequentially ordered, starting from the
              number 1.
            DESCRIPTION

            optional :scope, :symbol, array: true do
              import_shared :snake_case_name_validator
              description <<~DESCRIPTION
                The name of fields which this models unique position should be scoped to.
              DESCRIPTION
            end

            import_shared :field_comment
          end
        end
      end
    end
  end
end
