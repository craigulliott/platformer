module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module ZeroToNullCoercion
              DSLCompose::SharedConfiguration.add :zero_to_null_coercion do
                add_unique_method :zero_to_null do
                  description <<~DESCRIPTION
                    Ensures that the value of this field can not be the number 0.
                    If it is the number 0, then it will be converted automatically
                    to null. This coercion logic will be installed into active record,
                    and a constraint will be added to the database to ensure there are
                    no 0 values. If used on an array field, then vaues of 0 will be
                    automatically removed from the array and the database constraint will
                    forbid any arrays with a value of 0.
                  DESCRIPTION

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for converting 0 to null
                      on this field. This will be used to generate documentation,
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
