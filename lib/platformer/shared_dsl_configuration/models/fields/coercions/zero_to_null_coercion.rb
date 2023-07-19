module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module ZeroToNullCoercion
              DSLCompose::SharedConfiguration.add :zero_to_null_coercion do
                add_method :uppercase do
                  description <<-DESCRIPTION
                    Ensures that the value of this field can not be the number 0.
                    If it is the number 0, then it will be converted automatically
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
