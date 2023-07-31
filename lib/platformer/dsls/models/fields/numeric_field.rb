module Platformer
  module DSLs
    module Models
      module Fields
        module NumericField
          def self.included klass
            klass.define_dsl :numeric_field do
              description <<-DESCRIPTION
                Add a numeric field to this model. The numeric type can store numbers
                with a lot of digits. Typically, you use the numeric type for numbers
                that require exactness such as monetary amounts or quantities.
              DESCRIPTION

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
              end

              # add an optional attribute which can be used to
              # denote this as an array of numerics
              optional :array, :boolean do
                description <<-DESCRIPTION
                  If true, then this field will be an array of numerics, and
                  will be backed by a `numeric(precision,scale)[]` type in PostgreSQL.
                DESCRIPTION
              end

              optional :precision, :integer do
                description <<-DESCRIPTION
                  If provided, then precision is the total number of digits
                  which can be held in this field. The largest value you can provide
                  here is 1000, but if you ommit this argument then a default
                  value of 131072 is actually used.
                DESCRIPTION

                validate_greater_than 0
                # the max number of digits you can provide to PostgreSQL
                # is 1000, although if you ommit this argument then a default
                # of 131072 is actually used.
                validate_less_than_or_equal_to 1000
              end

              optional :scale, :integer do
                description <<-DESCRIPTION
                  Must be used in conjunction with the precision value, the scale
                  is the number of digits in the fraction part of a number. For
                  example, the number 1234.567 has the precision 7 and scale 3.
                  The largest value you can provide here is 1000, but if you ommit
                  this argument then a default value of 16383 is actually used.
                DESCRIPTION

                validate_greater_than 0
                # the max number of digits you can provide to PostgreSQL
                # is 1000, although if you ommit this argument then a default
                # of 16383 is actually used.
                validate_less_than_or_equal_to 1000
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :float
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :numeric_validators
            end
          end
        end
      end
    end
  end
end
