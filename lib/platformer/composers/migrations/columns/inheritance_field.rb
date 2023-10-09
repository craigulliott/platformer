# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        class InheritanceField < Parsers::Models
          # process all the STI classes and add their class names to the enum which
          # will be used as the data type for the underlying column, the first time
          # an STI class of each type is processed, the enum and underlying column will
          # be created
          for_models only_sti_classes: true do |model_definition_class:, schema:|
            base_definition_class = model_definition_class.sti_base_class
            table = base_definition_class.table_structure

            # default column name is :type, but it can be overridden by calling
            # the `inheritance_field` DSL on the model definition class
            sti_column_name = :type
            for_dsl :inheritance_field, first_use_only: true, on_ancestor_class: true do |name:|
              sti_column_name = name
            end

            enum_name = :"#{table.name}_#{sti_column_name.to_s.pluralize}"

            enum_value = model_definition_class.name.gsub(/Model\z/, "")

            # if the enum already exists, then add this class name to the list of possible values
            if schema.has_enum? enum_name
              schema.enum(enum_name).add_value enum_value

            # if the enum doesn't exist yet, then this is the first time we're processing
            # an STI class of this type, so we create the enum and the underlying column
            else
              enum = schema.add_enum enum_name, [enum_value], description: <<~DESCRIPTION
                This type is for the STI enum column `#{sti_column_name}` on the `#{table.schema.name}'.'#{table.name}` table.
              DESCRIPTION

              # add the column to the DynamicMigrations table
              enum_type_name = enum.full_name
              table.add_column sti_column_name, enum_type_name, enum: enum, null: false, description: <<~DESCRIPTION
                Add an enum column called `#{sti_column_name}` which will be used as this models
                single table inheritance type column.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
