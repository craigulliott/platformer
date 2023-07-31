module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module AllowNull
          DSLCompose::SharedConfiguration.add :allow_null do
            add_unique_method :allow_null do
              description <<-DESCRIPTION
                If true, then a null value is permitted for this field. This
                is validated at the API level and with active record validations.
                The underlying postgres column will also be configured to allow
                NULL values
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
