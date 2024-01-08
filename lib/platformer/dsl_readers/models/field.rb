module Platformer
  module DSLReaders
    module Models
      # todo: not tested
      class Field < DSLCompose::Reader::ExecutionReader
        class ColumnNameError < StandardError
        end

        def column_name
          if arguments.has_argument? :name
            arguments.name
          elsif arguments.has_argument? :prefix
            prefix = arguments.prefix
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            case dsl_name
            when :country_field
              :"#{name_prepend}country"
            when :language_field
              :"#{name_prepend}language"
            when :currency_field
              :"#{name_prepend}currency"
            else
              raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
            end
          else
            raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
          end
        end

        def column_names
          column_names = []
          if arguments.has_argument? :name
            column_names << arguments.name
          elsif arguments.has_argument? :prefix
            prefix = arguments.prefix
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            case dsl_name
            when :country_field
              column_names << :"#{name_prepend}country"
            when :language_field
              column_names << :"#{name_prepend}language"
            when :currency_field
              column_names << :"#{name_prepend}currency"
            when :phone_number_field
              column_names << :"#{name_prepend}phone_number"
              column_names << :"#{name_prepend}dialing_code"
            else
              raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
            end
          else
            raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
          end
          column_names
        end
      end
    end
  end
end
