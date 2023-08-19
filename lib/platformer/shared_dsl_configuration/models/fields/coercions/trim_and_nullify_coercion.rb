module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module TrimAndNullifyCoercion
              DSLCompose::SharedConfiguration.add :trim_and_nullify_coercion do
                add_unique_method :trim_and_nullify do
                  description <<~DESCRIPTION
                    Ensures that the value of this field can not be an empty string
                    or have white space at the beginning or end of the value. Any
                    whitespace will automatically be trimmed from the start and end
                    of the value, and any empty strings will be converted automatically
                    to null. This coercion logic will be installed into active record.
                    A validation will also be added to the database to assert that this
                    coercion was applied to any records before they are attempted to be
                    saved.
                  DESCRIPTION

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for adding trim and nullify
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
