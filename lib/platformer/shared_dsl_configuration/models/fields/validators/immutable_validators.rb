module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module NumericValidators
              # immutable validators which are shared between all fields
              DSLCompose::SharedConfiguration.add :immutable_validators do
                add_method :validate_immutable do
                  description <<-DESCRIPTION
                    Ensures that the value of this field can not be changed
                    after it is initially created. This will create an active
                    record validation, a database constraint and will be used
                    in API validation and generated documentation.
                  DESCRIPTION

                  optional :message, :string do
                    description <<-DESCRIPTION
                      The message which will be raised if the validation fails.
                    DESCRIPTION
                  end
                end

                add_method :validate_immutable_once_set do
                  description <<-DESCRIPTION
                    Ensures that the value of this field can not be changed
                    after it is has been set. This means that the value can
                    initially be set to null, and can remain as null for some
                    time, but if the field is ever provided with a value then
                    it will be immutable thereafter. This will create an active
                    record validation, a database constraint and will be used
                    in API validation and generated documentation.
                  DESCRIPTION

                  optional :message, :string do
                    description <<-DESCRIPTION
                      The message which will be raised if the validation fails.
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
