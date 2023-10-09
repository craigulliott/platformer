module Platformer
  module Composers
    module Migrations
      module Associations
        module BelongsTo
          class CreateColumn < Parsers::Models
            for_dsl :belongs_to do |is_sti_class:, model_definition_class:, module_name:, name:, model:, through:, allow_null:, local_columns:, foreign_columns:, description:, deferrable:, initially_deferred:, on_delete:, on_update:|
              if is_sti_class
                raise StiClassUncomposableError, "Can not add associations on STI models, add the association to the STI model base class instead"
              end

              local_table = model_definition_class.table_structure
              foreign_model = model || "#{module_name}::#{name.to_s.classify}Model".constantize
              foreign_table = foreign_model.table_structure

              if local_columns.empty? && through.nil?
                # generate the local column name based off the name of the association
                column_name = :"#{name}_id"

                unless local_table.has_column? column_name
                  # add this column to the local table
                  local_table.add_column(column_name, :uuid, null: allow_null, description: <<~DESCRIPTION)
                    #{description}
                    This table belongs to `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
                  DESCRIPTION

                  add_documentation <<~DESCRIPTION
                    A uuid column named `#{column_name}` was automatically created on the local table.
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
