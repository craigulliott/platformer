module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module Action
          def self.included klass
            klass.define_dsl :action do
              description <<~DESCRIPTION
                Adds a mutation based on one of this models action fields.
              DESCRIPTION

              requires :action_field_name, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  The name of the action field which this action is for
                DESCRIPTION
              end

              add_method :fields do
                description <<~DESCRIPTION
                  A list of this models fields which can be changed via this mutation.
                DESCRIPTION

                requires :fields, :symbol, array: true do
                  import_shared :snake_case_name_validator

                  description <<~DESCRIPTION
                    The list of field names.
                  DESCRIPTION
                end
              end
            end
          end
        end
      end
    end
  end
end
