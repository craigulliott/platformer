module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Unique
            DSLCompose::SharedConfiguration.add :unique_field do
              add_unique_method :unique do
                description <<-DESCRIPTION
                  If used within a field dsl, then this will add a unique
                  database constraint to the field.
                DESCRIPTION

                optional :scope, :symbol, array: true do
                  description <<-DESCRIPTION
                    An optional list of fields which will be used to scope
                    the uniqueness constraint for this field.
                  DESCRIPTION
                end

                optional :comment, :string do
                  description <<-DESCRIPTION
                    A comment which explains the reason for uniqueness
                    on this field. This will be used to generate documentation,
                    and error messages
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
