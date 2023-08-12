# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all float columns to their respective tables within DynamicMigrations
        class FloatColumns < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each time the :float_field DSL was used on this Model
            for_dsl_or_inherited_dsl :float_field do |name:, array:, reader:|
              # update the dynamic documentation
              description <<~DESCRIPTION
                Update DynamicMigrations and add an #{array ? "array of floats" : "float"}
                column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              DESCRIPTION

              # is the column allowed to be null
              allow_null = method_called? :allow_null
              if allow_null
                description "This column can be null."
              end

              # get the comment for this column, or null if one was not provided
              comment_text = reader.comment&.comment

              # the default value for this column, or null if one was not provided
              default = reader.default&.default

              # The data type of the column. Where n is a precision value between 1 and 24, PostgreSQL
              # accepts float(n) and assumes the data type of `real`. For greater precision, the double
              # type should be used.
              data_type = array ? :"real[]" : :real

              # add the column to the DynamicMigrations table
              table.add_column name, data_type, null: allow_null, default: default, description: comment_text
            end
          end
        end
      end
    end
  end
end
