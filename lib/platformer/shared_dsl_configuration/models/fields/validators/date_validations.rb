module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module DateValidators
              # date validators which are shared between date and time fields
              DSLCompose::SharedConfiguration.add :date_validators do
              end
            end
          end
        end
      end
    end
  end
end
