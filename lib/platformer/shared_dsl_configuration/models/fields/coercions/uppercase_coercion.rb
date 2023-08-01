module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module UppercaseCoercion
              DSLCompose::SharedConfiguration.add :uppercase_coercion do
                add_unique_method :uppercase do
                  description <<-DESCRIPTION
                    Ensures that the value of this field is an uppercase string.
                    If it contains lowercase letters, then it will be converted automatically
                    to uppercase. This coercion logic will be installed into active record,
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
