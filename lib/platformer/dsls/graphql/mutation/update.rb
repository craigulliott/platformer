module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module Update
          def self.included klass
            klass.define_dsl :update do
              description <<~DESCRIPTION
                Adds a mutation to update a new record of this model.
              DESCRIPTION

              add_method :fields do
                description <<~DESCRIPTION
                  A list of this models fields which can be set via this update mutation.
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
