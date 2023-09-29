# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Associations
        class BelongsTo < Parsers::AllModels
          for_dsl :belongs_to do |active_record_class:, module_name:, name:, model:, through:, local_columns:, foreign_columns:|
            foreign_model_class_name = model&.active_record_class&.name || "#{module_name}::#{name.classify}Model"

            add_documentation <<~DESCRIPTION
              Add a belongs to association between this model and #{foreign_model_class_name}.
            DESCRIPTION

            warn "add a check that there are the same number of local_columns and foreign_columns"
            warn "no test case for local and foreign column names being specified"
            if local_columns.any? || foreign_columns.any?
              if through
                raise "not currently supported"
              end

              # a map of the local and foreign column names used to resolve this association
              column_name_map = {}
              foreign_columns.each_with_index do |column_name, i|
                column_name_map[column_name] = local_columns[i]
              end

              # find the foreign model using these arguments
              active_record_class.install_method name do
                # the column names on the remote model with the corresponding values from the local model
                finder_args = {}
                column_name_map.each do |remote_column_name, local_column_name|
                  finder_args[remote_column_name] = send(local_column_name)
                end

                foreign_model_class_name.consantize.find_by finder_args
              end

            else
              opts = {}
              opts[:class_name] = foreign_model_class_name
              if through
                opts[:through] = through
              end
              active_record_class.belongs_to name, **opts
            end
          end
        end
      end
    end
  end
end
