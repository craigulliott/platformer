module Platformer
  module Parsers
    # A convenience wrapper for a DSL compose parser which removes some
    # common code from all the field parsers
    module ForFieldMacros
      ALL_FIELDS = [
        :boolean_field,
        :char_field,
        :citext_field,
        :date_field,
        :date_time_field,
        :double_field,
        :email_field,
        :enum_field,
        :float_field,
        :integer_field,
        :json_field,
        :numeric_field,
        :phone_number_field,
        :text_field
      ]

      NUMERIC_FIELDS = [
        :integer_field,
        :float_field,
        :numeric_field,
        :double_field
      ]

      STRING_FIELDS = [
        :char_field,
        :text_field,
        :citext_field
      ]

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def for_field field_name, &block
          for_fields [field_name], &block
        end

        def for_all_fields except: [], &block
          except = [except] unless except.is_a?(Array)
          for_fields ALL_FIELDS - except, &block
        end

        def for_numeric_fields except: [], &block
          except = [except] unless except.is_a?(Array)
          for_fields NUMERIC_FIELDS - except, &block
        end

        def for_string_fields except: [], &block
          except = [except] unless except.is_a?(Array)
          for_fields STRING_FIELDS - except, &block
        end
      end
    end
  end
end
