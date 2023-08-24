module Platformer
  module Composers
    module Migrations
      module Associations
        # a shared composer for has_one or has_many
        class HasMany < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # for each time the provided fields DSL was used on this Model
            for_dsl_or_inherited_dsl :has_many do |dsl_name:, foreign_model:, local_column_names:, foreign_column_names:, comment:, deferrable:, initially_deferred:, on_delete:, on_update:|
              local_table = child_class.table_structure
              foreign_table = foreign_model.table_structure

              allow_null = method_called?(:allow_null)

              description <<~DESCRIPTION
                Create a has_many association, where `#{local_table.schema.name}'.'#{local_table.name}` records
                can have many `#{foreign_table.schema.name}'.'#{foreign_table.name}` records.
              DESCRIPTION

              # get (or build) the foreign columns (which also asserts that they exist)
              foreign_columns = []
              if foreign_column_names.empty?
                # generate the foreign column name based off the name of the foreign table
                column_name = :"#{local_table.name.to_s.singularize}_id"
                # add this column to the foreign table
                foreign_columns << foreign_table.add_column(column_name, :uuid, null: allow_null, description: <<~DESCRIPTION)
                  #{comment}
                  This table belongs to `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
                DESCRIPTION

                description <<~DESCRIPTION
                  A uuid column named `#{column_name}` was automatically created on the foreign table.
                DESCRIPTION

              else
                foreign_column_names.each do |column_name|
                  foreign_columns << foreign_table.column(column_name)
                end
              end

              # get the local columns (which also asserts that they exist)
              local_columns = []
              if local_column_names.empty?
                local_columns << local_table.column(:id)
              else
                local_column_names.each do |column_name|
                  local_columns << local_table.column(column_name)
                end
              end

              local_column_descriptions = local_columns.map { |c| "#{c.name} (#{c.data_type})" }
              foreign_column_descriptions = foreign_columns.map { |c| "#{c.name} (#{c.data_type})" }

              description <<~DESCRIPTION
                The association is between the foreign columns #{foreign_column_descriptions.to_sentence}
                and the local columns #{local_column_descriptions.to_sentence}.
              DESCRIPTION

              # if these tables are in the same database then create a
              # foreign key constraint
              if local_table.schema.database == foreign_table.schema.database

                # the values we need for the foreign key constraint
                local_column_names = local_columns.map(&:name)
                local_schema_name = local_table.schema.name
                local_table_name = local_table.name
                foreign_column_names = foreign_columns.map(&:name)

                on_delete_action = on_delete || :no_action
                on_update_action = on_update || :no_action

                on_delete_action_name = on_delete_action.to_s.tr("_", " ").upcase
                on_update_action_name = on_update_action.to_s.tr("_", " ").upcase

                foreign_key_name = :"has_many_from_#{local_table.name}"

                options = {
                  deferrable: deferrable,
                  initially_deferred: initially_deferred,
                  on_delete: on_delete_action,
                  on_update: on_update_action,
                  description: comment
                }

                description <<~DESCRIPTION
                  A foreign key constraint named #{foreign_key_name} was created between these columns.
                  The ON DELETE action is `#{on_delete_action_name}` and the ON UPDATE action is `#{on_update_action_name}`.
                DESCRIPTION

                if deferrable
                  description <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                else
                  description <<~DESCRIPTION
                    This constraint is not deferrable.
                  DESCRIPTION
                end

                # create the foreign key constraint
                foreign_table.add_foreign_key_constraint foreign_key_name, foreign_column_names, local_schema_name, local_table_name, local_column_names, **options
              else
                description <<~DESCRIPTION
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
