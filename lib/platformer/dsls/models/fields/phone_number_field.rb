module Platformer
  module DSLs
    module Models
      module Fields
        module PhoneNumberField
          def self.included klass
            klass.define_dsl :phone_number_field do
              namespace :fields
              title "Add a Phone Number field to your Model"
              description <<~DESCRIPTION
                Add an phone_number field to this model. The phone_number is backed
                a seperate columns for the dialing_code and the phone_number, and
                automatically handles validation and provides a variety of formatting
                options for displaying numbers.
              DESCRIPTION

              # Arguments
              #
              # an optional prefix for this fields name
              optional :prefix, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  An optional prefix to use for the name of this field. This prefix
                  will be prepended to the column names which back this field, and
                  to the presenter methods, graphql queries and mutations.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :dialing_code, :string do
                  validate_in Constants::ISO::DialingCode.values
                end
                requires :phone_number, :string do
                  validate_format(/\A\d+\z/)
                end
              end

              add_unique_method :database_default do
                requires :dialing_code, :string
                requires :phone_number, :string
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :unique_field
              import_shared :field_description
              import_shared :immutable_validators
            end
          end
        end
      end
    end
  end
end
