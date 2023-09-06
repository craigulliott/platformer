module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module SnakeCaseNameValidator
              DSLCompose::SharedConfiguration.add :snake_case_name_validator do
                validate_format(/\A[a-z][a-z0-9]*(_[a-z][a-z0-9]*)*\Z/)
              end
            end
          end
        end
      end
    end
  end
end
