module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Description
            DSLCompose::SharedConfiguration.add :default do
              add_unique_method :default do
                description <<~DESCRIPTION
                  This method is used to set a default value for a field, this default
                  is set within active record and should be persisted to the database when
                  the record is created. It does not configure the underlying database table
                  to have a default value or expression. If you want to do that, then use
                  the `database_default`.
                DESCRIPTION

                requires :default, :string do
                  description <<~DESCRIPTION
                    The default value to set for this field.
                  DESCRIPTION
                end
              end
            end

            DSLCompose::SharedConfiguration.add :numeric_default do
              add_unique_method :default do
                description <<~DESCRIPTION
                  This method is used to set a default value for a numeric field, this default
                  is set within active record and should be persisted to the database when
                  the record is created. It does not configure the underlying database table
                  to have a default value or expression. If you want to do that, then use
                  the `database_default`.
                DESCRIPTION

                requires :default, :float do
                  description <<~DESCRIPTION
                    The default value to set for this field.
                  DESCRIPTION
                end
              end
            end

            warn "not tested"
            DSLCompose::SharedConfiguration.add :database_default do
              add_unique_method :database_default do
                description <<~DESCRIPTION
                  This method is used to set a default value on the underlying database
                  column. This should be a string, and can optionally be an postres expression
                  such as `nextval()` or `CURRENT_TIMESTAMP`.
                DESCRIPTION

                requires :default, :string do
                  description <<~DESCRIPTION
                    The value or expression to be used within the database to set
                    the default value.
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
