module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Unique
            DSLCompose::SharedConfiguration.add :unique_field do
              add_unique_method :unique do
                description <<~DESCRIPTION
                  If used within a field dsl then this will enforce uniqueness for this
                  field.
                DESCRIPTION

                # add `deferrable: boolean` and `initially_deferred: boolean` options
                import_shared :deferrable_constraint

                optional :where, :string do
                  description <<~DESCRIPTION
                    An optional SQL condition which can be used to limit this uniqueness
                    to a subset of records. If you provide a value for where, then it is not
                    possible to set 'deferrable: true', this is because the underlying constraint
                    will be enforced by a unique index rather than a unique_contraint, and indexes
                    can not be deferred in postgres.
                  DESCRIPTION
                end

                optional :scope, :symbol, array: true do
                  description <<~DESCRIPTION
                    An optional list of fields which will be used to scope
                    the uniqueness constraint for this field.
                  DESCRIPTION
                end

                optional :message, :string do
                  description <<~DESCRIPTION
                    The message which will be displayed if the validation fails.
                  DESCRIPTION
                end

                optional :description, :string do
                  description <<~DESCRIPTION
                    A description which explains the reason for uniqueness
                    on this field. This will be used to generate documentation,
                    and error messages
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
