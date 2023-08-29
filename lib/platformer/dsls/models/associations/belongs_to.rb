module Platformer
  module DSLs
    module Models
      module Associations
        module BelongsTo
          def self.included klass
            klass.define_dsl :belongs_to do
              namespace :associations

              description <<~DESCRIPTION
                Specifies a one-to-one association with another class. This will
                automatically create the appropriate foreign key column on this
                model, build the appropriate foreign key constraint and setup
                the ActiveRecord associations.
              DESCRIPTION

              requires :foreign_model, :class do
                description <<~DESCRIPTION
                  The Model class which this Model belongs to.
                DESCRIPTION
              end

              optional :local_column_names, :symbol, array: true do
                description <<~DESCRIPTION
                  Override the default behaviour of generating a new column on this
                  model, and specify the name of one or more existing columns to use
                  instead.
                DESCRIPTION
              end

              optional :foreign_column_names, :symbol, array: true do
                description <<~DESCRIPTION
                  The name of one or more existing columns on the other (foreign) model
                  which make up the other side of this relationnship.
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
                  Configure how to handle the record in the local table when
                  the foreign row it is constrainted to is updated. The default is
                  `:restrict` but the possible values are:
                  options are.

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
                  Configure how to handle the record in the local table when
                  the foreign row it is constrainted to is deleted. The default is
                  `:restrict` but the possible values are:
                  options are.

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
                  If true, and `local_column_names` were not provided, then the
                  automatically generated column which is added to the local
                  table can be `null`, which makes the `belongs_to` association optional.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
