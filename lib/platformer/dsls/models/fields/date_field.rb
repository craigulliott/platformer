module Platformer
  module DSLs
    module Models
      module Fields
        module DateField
          def self.included klass
            klass.define_dsl :date_field do
              description "Add a date field to this model."

              # the name of the field
              requires :name, :symbol do
                description "The name of your date field. It must end with _at"
                validate_format(/\A[a-z]+(_[a-z]+)*_at\Z/)
                validate_length minimum: 1, maximum: 63

                validate_not_in [
                  # Reserved for the automatically set ActiveRecord columns
                  :created_at,
                  # Reserved for the automatically set ActiveRecord columns
                  :updated_at
                ]
              end
            end
          end
        end
      end
    end
  end
end
