module Platformer
  module DSLs
    module GraphQL
      module Queries
        module RootNode
          def self.included klass
            klass.define_dsl :root_node do
              description <<~DESCRIPTION
                Makes this model available via a root node query.
              DESCRIPTION

              add_method :by_id do
                description <<~DESCRIPTION
                  Provides an argument and installs functionality
                  to allow this model to be queried by it's ID.
                DESCRIPTION
              end

              add_method :by_exact_string do
                description <<~DESCRIPTION
                  Allows for a string search against one of the models fields.
                DESCRIPTION

                requires :field_name, :symbol do
                  description <<~DESCRIPTION
                    The name of the field we are searching against.
                  DESCRIPTION
                end

                optional :required, :boolean do
                  description <<~DESCRIPTION
                    If true. then using this argument is required when querying this collection.
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
