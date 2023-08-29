# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all numeric columns to their respective tables within DynamicMigrations
        class Numeric < Parsers::FinalModels::ForFields
          class PrecisionMustBeProvidedError < StandardError
          end

          for_field :numeric_field do |name:, table:, allow_null:, comment_text:, default:, array:, reader:, precision:, scale:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of numerics" : "numeric"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            if precision.nil?
              unless scale.nil?
                raise PrecisionMustBeProvided, "Precision must be provided if scale is provided"
              end
              data_type = "numeric"
            else
              data_type = if scale.nil?
                "numeric(#{precision})"
              else
                "numeric(#{precision},#{scale})"
              end
            end

            if array
              data_type += "[]"
            end

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
