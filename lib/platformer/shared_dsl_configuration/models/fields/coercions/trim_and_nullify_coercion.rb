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
                    to null. This coercion logic will be installed into active record,
                    the API and the database as a stored procedure.
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
