module Platformer
  module DSLReaders
    module Models
      warn "not tested"
      class Field < DSLCompose::ReaderBase
        class ColumnNameError < StandardError
        end

        def column_name
          if arguments.has_argument? :name
            final_args[:column_name] = arguments.name
          elsif arguments.has_argument? :prefix
            prefix = arguments.prefix
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            case dsl_name
            when :country_field
              final_args[:column_name] = :"#{name_prepend}country"
            when :language_field
              final_args[:column_name] = :"#{name_prepend}language"
            when :currency_field
              final_args[:column_name] = :"#{name_prepend}currency"
            else
              raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
            end
          else
            raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
          end
        end

        def column_names
          final_args[:column_names] = []
          if arguments.has_argument? :name
            final_args[:column_names] << arguments.name
          elsif arguments.has_argument? :prefix
            prefix = arguments.prefix
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            case dsl_name
            when :country_field
              final_args[:column_names] << :"#{name_prepend}country"
            when :language_field
              final_args[:column_names] << :"#{name_prepend}language"
            when :currency_field
              final_args[:column_names] << :"#{name_prepend}currency"
            when :phone_number_field
              final_args[:column_names] << :"#{name_prepend}phone_number"
              final_args[:column_names] << :"#{name_prepend}dialing_code"
            else
              raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
            end
          else
            raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
          end
        end
      end
    end
  end
end
