module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module TrimAndNullifyCoercion
              DSLCompose::SharedConfiguration.add :remove_null_array_values_coercion do
                add_unique_method :remove_null_array_values do
                  description <<~DESCRIPTION
                    Ensures that the value of this field does not contain any null values.
                    Any null values will automatically be removed before saving the record.
                    This coercion logic will be installed into active record. A validation
                    will also be added to the database to assert that the column has no
                    null values. This is only compatibile with array fields.
                  DESCRIPTION

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for automatically removing any
                      null values from this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
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
end
