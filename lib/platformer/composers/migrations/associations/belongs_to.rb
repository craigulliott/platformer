module Platformer
  module Composers
    module Migrations
      module Associations
        class BelongsTo < Parsers::FinalModels
          for_dsl :belongs_to do |model_definition_class:, module_name:, name:, model:, through:, allow_null:, local_columns:, foreign_columns:, description:, deferrable:, initially_deferred:, on_delete:, on_update:|
            local_table = model_definition_class.table_structure
            foreign_model = model || "#{module_name}::#{name.classify}Model".constantize
            foreign_table = foreign_model.table_structure

            add_documentation <<~DESCRIPTION
              Create an association between the `#{local_table.schema.name}'.'#{local_table.name}` table
              and the foreign `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
            DESCRIPTION

            # get (or build) the foreign columns (which also asserts that they exist)
            local_cols = []
            if local_columns.empty?
              # generate the local column name based off the name of the association
              column_name = :"#{name}_id"
              # if the column already exists, then add it to the array of columns which
              # will be used for the foreign key constraint
              if local_table.has_column? column_name
                local_cols << local_table.column(column_name)

              # automatically add this column to the foreign table
              else
                # add this column to the local table
                local_cols << local_table.add_column(column_name, :uuid, null: allow_null, description: <<~DESCRIPTION)
                  #{description}
                  This table belongs to `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
                DESCRIPTION

                add_documentation <<~DESCRIPTION
                  A uuid column named `#{column_name}` was automatically created on the local table.
                DESCRIPTION
              end
            else
              local_columns.each do |column_name|
                local_cols << local_table.column(column_name)
              end
            end

            # get the foreign columns (which also asserts that they exist)
            foreign_cols = []
            if foreign_columns.empty?
              foreign_cols << foreign_table.column(:id)
            else
              foreign_columns.each do |column_name|
                foreign_cols << foreign_table.column(column_name)
              end
            end

            local_column_descriptions = local_cols.map { |c| "#{c.name} (#{c.data_type})" }
            foreign_column_descriptions = foreign_cols.map { |c| "#{c.name} (#{c.data_type})" }

            add_documentation <<~DESCRIPTION
              The association is between the local columns #{local_column_descriptions.to_sentence}
              and the foreign columns #{foreign_column_descriptions.to_sentence}.
            DESCRIPTION

            # if these tables are in the same database then create a
            # foreign key constraint
            if local_table.schema.database == foreign_table.schema.database

              # the values we need for the foreign key constraint
              local_columns = local_cols.map(&:name)
              foreign_schema_name = foreign_table.schema.name
              foreign_table_name = foreign_table.name
              foreign_columns = foreign_cols.map(&:name)

              on_delete_action = on_delete || :no_action
              on_update_action = on_update || :no_action

              on_delete_action_name = on_delete_action.to_s.tr("_", " ").upcase
              on_update_action_name = on_update_action.to_s.tr("_", " ").upcase

              foreign_key_name = :"belongs_to_#{foreign_table.name}"

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
              local_table.add_foreign_key_constraint foreign_key_name, local_columns, foreign_schema_name, foreign_table_name, foreign_columns, **options
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
