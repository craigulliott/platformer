module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module Create
          def self.included klass
            klass.define_dsl :create do
              description <<~DESCRIPTION
                Adds a mutation to create a new record of this model.
              DESCRIPTION

              add_method :fields do
                description <<~DESCRIPTION
                  A list of this models fields which can be set via this create mutation.
                DESCRIPTION

                requires :fields, :symbol, array: true do
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
