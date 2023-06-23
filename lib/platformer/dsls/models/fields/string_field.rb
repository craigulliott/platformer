module Platformer
  module DSLs
    module Models
      module Fields
        module StringField
          def self.included klass
            klass.define_dsl :string_field do
              description "Add a string field to this model."

              # the name of the field
              requires :name, :symbol do
                description "The name of your field"
                validate_format(/\A[a-z]+(_[a-z]+)*\Z/)
                validate_length minimum: 1, maximum: 63

                # can not be called "type" because it is reserved by STI models
                validate_not_in [
                  # stage is used by state machines
                  :stage,
                  # timestamped booleans
                  :undeleted,
                  :deleted_at,
                  # timestamped booleans
                  # :un*,
                  # :*_at,
                  :stage,
                  # Reserved for the primary key
                  :id,
                  # Reserved for foreign keys
                  # *_id,
                  # Specifies that the model uses Single Table Inheritance.
                  :type,
                  # Automatically gets set to the current date and time when the record is first created.
                  :created_at,
                  # Automatically gets set to the current date and time whenever the record is created or updated.
                  :updated_at
                  # Adds optimistic locking to a model.
                  # lock_version,
                  # # Stores the type for polymorphic associations.
                  # *_type,
                  # # Used to cache the number of belonging objects on associations. For example, a comments_count column in an Article class that has many instances of Comment will cache the number of existent comments for each article.
                  # (table_name)_count,
                ]
              end

              add_method :case_insensitive
              add_method :required
              add_method :unique
              add_method :description do
                requires :description, :string
              end
            end
          end
        end
      end
    end
  end
end
