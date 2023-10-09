module Platformer
  module Composers
    module Migrations
      module Associations
        module HasMany
          class Constraint < Parsers::Models
            for_dsl :has_many do |is_sti_class:, model_definition_class:, module_name:, name:, model:, through:, allow_null:, local_columns:, foreign_columns:, description:, deferrable:, initially_deferred:, on_delete:, on_update:|
              if is_sti_class
                raise StiClassUncomposableError, "Can not add associations on STI models, add the association to the STI model base class instead"
              end

              # no foreign key constraint on associations which are "through" another model
              next if through

              local_table = model_definition_class.table_structure
              foreign_model = model || "#{module_name}::#{name.to_s.classify}Model".constantize
              foreign_table = foreign_model.table_structure

              add_documentation <<~DESCRIPTION
                Create a has_many association, where `#{local_table.schema.name}'.'#{local_table.name}` records
                can have many `#{foreign_table.schema.name}'.'#{foreign_table.name}` records.
              DESCRIPTION

              # get (or build) the foreign columns (which also asserts that they exist)
              foreign_cols = []
              if foreign_columns.empty?
                # generate the foreign column name based off the name of the foreign table
                column_name = :"#{local_table.name.to_s.singularize}_id"
                foreign_cols << foreign_table.column(column_name)
              else
                foreign_columns.each do |column_name|
                  foreign_cols << foreign_table.column(column_name)
                end
              end

              # get the local columns (which also asserts that they exist)
              local_cols = []
              if local_columns.empty?
                local_cols << local_table.column(:id)
              else
                local_columns.each do |column_name|
                  local_cols << local_table.column(column_name)
                end
              end

              local_column_descriptions = local_cols.map { |c| "#{c.name} (#{c.data_type})" }
              foreign_column_descriptions = foreign_cols.map { |c| "#{c.name} (#{c.data_type})" }

              add_documentation <<~DESCRIPTION
                The association is between the foreign columns #{foreign_column_descriptions.to_sentence}
                and the local columns #{local_column_descriptions.to_sentence}.
              DESCRIPTION

              # if these tables are in the same database then create a
              # foreign key constraint
              if local_table.schema.database == foreign_table.schema.database
                # the values we need for the foreign key constraint
                local_columns = local_cols.map(&:name)
                local_schema_name = local_table.schema.name
                local_table_name = local_table.name
                foreign_columns = foreign_cols.map(&:name)

                on_delete_action = on_delete || :no_action
                on_update_action = on_update || :no_action

                on_delete_action_name = on_delete_action.to_s.tr("_", " ").upcase
                on_update_action_name = on_update_action.to_s.tr("_", " ").upcase

                foreign_key_name = :"#{local_table_name}_has_many_#{name}"

                options = {
                  deferrable: deferrable,
                  initially_deferred: initially_deferred,
                  on_delete: on_delete_action,
                  on_update: on_update_action,
                  description: description
                }

                add_documentation <<~DESCRIPTION
                  A foreign key constraint named #{foreign_key_name} was created between these columns.
                  The ON DELETE action is `#{on_delete_action_name}` and the ON UPDATE action is `#{on_update_action_name}`.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                else
                  add_documentation <<~DESCRIPTION
                    This constraint is not deferrable.
                  DESCRIPTION
                end

                # create the foreign key constraint
                foreign_table.add_foreign_key_constraint foreign_key_name, foreign_columns, local_schema_name, local_table_name, local_columns, **options
              else
                add_documentation <<~DESCRIPTION
                  A foreign key constraint was not created because the tables are in different databases.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
