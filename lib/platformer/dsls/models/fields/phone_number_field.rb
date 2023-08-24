module Platformer
  module DSLs
    module Models
      module Fields
        module PhoneNumberField
          def self.included klass
            klass.define_dsl :phone_number_field do
              description <<~DESCRIPTION
                Add an phone_number field to this model. The phone_number is backed
                a seperate columns for the dialing_code and the phone_number, and
                automatically handles validation and provides a variety of formatting
                options for displaying numbers.
              DESCRIPTION

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
                # Reserved for timestamps
                validate_not_end_with :_at
              end

              # Methods
              #
              add_unique_method :default do
                requires :dialing_code, :string do
                  validate_format(/\+\d+/)
                end
                requires :phone_number, :string do
                  validate_format(/\d+/)
                end
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
            end
          end
        end
      end
    end
  end
end
