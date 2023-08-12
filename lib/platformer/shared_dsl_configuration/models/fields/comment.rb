module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Comment
            DSLCompose::SharedConfiguration.add :field_comment do
              add_unique_method :comment do
                description <<~DESCRIPTION
                  This method is used to describe a specific use of this
                  field within a model, this description will be added to
                  the database column as a comment, and will be used to
                  generate API documentation.
                DESCRIPTION

                requires :comment, :string do
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
