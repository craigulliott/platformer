module Platformer
  module DSLs
    module Models
      module Associations
        module HasOne
          def self.included klass
            klass.define_dsl :has_one do
              description <<~DESCRIPTION
                Specifies a one-to-one association with another class. This will
                automatically create the appropriate foreign key column on the other
                model, build the appropriate foreign key constraint and setup
                the ActiveRecord associations.
              DESCRIPTION

              requires :foreign_model, :class do
                description <<~DESCRIPTION
                  The Model class which this Model has one of.
                DESCRIPTION
              end

              optional :local_column_names, :symbol, array: true do
                description <<~DESCRIPTION
                  The name of one or more existing columns on the this model
                  which make up this side of association. If this is ommited
                  then the default column name `id` is assumed.
                DESCRIPTION
              end

              optional :foreign_column_names, :symbol, array: true do
                description <<~DESCRIPTION
                  Override the default behaviour of generating a new column on the
                  foreign model, and specify the name of one or more existing columns
                  to use instead.
                DESCRIPTION
              end

              optional :comment, :string do
                description <<~DESCRIPTION
                  A comment which explains the reason for this association
                  on this model. This will be used to generate documentation,
                  and will be added as a comment to the database constraint.
                DESCRIPTION
              end

              # add `deferrable: boolean` and `initially_deferred: boolean` options
              import_shared :deferrable_constraint

              optional :on_update, :symbol do
                description <<~DESCRIPTION
                  Configure how to handle the record in the remote table when
                  the local row is updated. The default is `:restrict` but the
                  possible values are:

                  #{Shared::ReferentialActionDescription::DESCRIPTION}
                DESCRIPTION

                validate_in [
                  :no_action,
                  :restrict,
                  :cascade,
                  :set_null,
                  :set_default
                ]
              end

              optional :on_delete, :symbol do
                description <<~DESCRIPTION
                  Configure how to handle the record in the remote table when
                  the local is deleted. The default is `:restrict` but the
                  possible values are:

                  #{Shared::ReferentialActionDescription::DESCRIPTION}
                DESCRIPTION

                validate_in [
                  :no_action,
                  :restrict,
                  :cascade,
                  :set_null,
                  :set_default
                ]
              end

              add_unique_method :allow_null do
                description <<~DESCRIPTION
                  If true, and `foreign_column_names` were not provided, then the
                  automatically generated column which is added to the foreign
                  table can be `null`, which makes it's association back to this local
                  model optional.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
