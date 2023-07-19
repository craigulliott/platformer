module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module FieldNameValidators
              DSLCompose::SharedConfiguration.add :field_name_validators do
                validate_format(/\A[a-z]+(_[a-z]+)*\Z/)
                validate_length minimum: 1, maximum: 63

                validate_not_in [
                  # Reserved for the primary key
                  :id,
                  # Reserved for state machines
                  :stage,
                  # Reserved for undeletable records
                  :undeleted,
                  # Reserved for Single Table Inheritance.
                  :type,
                  # Reserved for ActiveRecords optimistic locking mechanism
                  :lock_version
                ]

                validate_not_end_with [
                  # Reserved for foreign keys
                  :_id,
                  # Reserved for timestamps
                  :_at,
                  # Reserved for the type part of polymorphic associations
                  :_type,
                  # Reserved for active records count cache column
                  :_count
                ]
              end
            end
          end
        end
      end
    end
  end
end
