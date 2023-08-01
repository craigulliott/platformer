module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module LowercaseCoercion
              DSLCompose::SharedConfiguration.add :lowercase_coercion do
                add_unique_method :lowercase do
                  description <<-DESCRIPTION
                    Ensures that the value of this field is a lowercase string.
                    If it contains uppercase letters, then it will be converted automatically
                    to lowercase. This coercion logic will be installed into active record,
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
