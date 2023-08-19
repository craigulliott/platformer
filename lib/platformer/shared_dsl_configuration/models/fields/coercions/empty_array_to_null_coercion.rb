module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module EmptyArrayToNullCoercion
              DSLCompose::SharedConfiguration.add :empty_array_to_null_coercion do
                add_unique_method :empty_array_to_null do
                  description <<~DESCRIPTION
                    Ensures that the value of this field can not be an empty Array. If
                    at empty object is provided then it will automatically be converted
                    to NULL. This coercion logic will be installed into active record.
                    A validation will also be added to the database to assert that this
                    coercion was applied to any records before they are attempted to be
                    saved. This can be used in conjunction with `allow_null: false` to
                    make an array with at least one item a requirement. This can only be
                    used on fields which have been set to `array: true`.
                  DESCRIPTION

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for adding coercing empty arrays
                      to null on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
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
