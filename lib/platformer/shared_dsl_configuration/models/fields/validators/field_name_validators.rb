module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module FieldNameValidators
              DSLCompose::SharedConfiguration.add :field_name_validators do
                import_shared :snake_case_name_validator
                validate_length minimum: 1, maximum: 63

                validate_not_in [
                  # Reserved for the primary key
                  :id,
                  # Reserved for state machines
                  :state_machine_current_state,
                  # Reserved for the automatically set ActiveRecord columns
                  :created_at,
                  :updated_at,
                  # Reserved for our soft delete mechanism
                  :deleted_at,
                  :undeleted,
                  # Reserved for Single Table Inheritance.
                  :type,
                  # Reserved for ActiveRecords optimistic locking mechanism
                  :lock_version,
                  # Reserved for Positionable models (manual sorting of records)
                  :position
                ]
              end
            end
          end
        end
      end
    end
  end
end
