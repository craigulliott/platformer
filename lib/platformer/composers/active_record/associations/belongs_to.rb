# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Associations
        class BelongsTo < Parsers::AllModels
          for_dsl :belongs_to do |active_record_class:, foreign_model:, as:, local_column_names:, foreign_column_names:|
            foreign_model_class_name = foreign_model.active_record_class.name
            association_name = as || foreign_model_class_name.split("::").last.underscore.to_sym

            add_documentation <<~DESCRIPTION
              Add a belongs to association between this model and #{foreign_model_class_name}.
            DESCRIPTION

            warn "add a check that there are the same number of local_column_names and foreign_column_names"
            warn "no test case for local and foreign column names being specified"
            if local_column_names.any? || foreign_column_names.any?
              # a map of the local and foreign column names used to resolve this association
              column_name_map = {}
              foreign_column_names.each_with_index do |column_name, i|
                column_name_map[column_name] = local_column_names[i]
              end

              # find the foreign model using these arguments
              active_record_class.install_method association_name do
                # the column names on the remote model with the corresponding values from the local model
                finder_args = {}
                column_name_map.each do |remote_column_name, local_column_name|
                  finder_args[remote_column_name] = send(local_column_name)
                end

                foreign_model_class_name.consantize.find_by finder_args
              end

            else
              active_record_class.belongs_to association_name, class_name: foreign_model_class_name
            end
          end
        end
      end
    end
  end
end
