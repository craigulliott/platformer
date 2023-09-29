module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Description
            DSLCompose::SharedConfiguration.add :field_description do
              add_unique_method :description do
                description <<~DESCRIPTION
                  This method is used to describe a specific use of this
                  field within a model, this description will be added to
                  the database column as a description, and will be used to
                  generate API documentation.
                DESCRIPTION

                requires :description, :string do
                  description "The description of this field"
                end
              end
            end
          end
        end
      end
    end
  end
end
