module Platformer
  module DSLs
    module Models
      module Fields
        module PhoneNumberField
          def self.included klass
            klass.define_dsl :phone_number_field do
              description "Add an phone number field to this model."
            end
          end
        end
      end
    end
  end
end
