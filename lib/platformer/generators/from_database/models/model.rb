module Platformer
  module Generators
    module FromDatabase
      warn "not tested"
      class Model < PlatformFile
        class UnexpectedColumnTypeError < StandardError
        end

        def initialize table
          super :model, table.schema.name, table.name

          # table description
          if table.has_description?
            add_section <<~RUBY
              description <<~DESCRIPTION
                #{word_wrap table.description, line_length: 80, indent: true}
              DESCRIPTION
            RUBY
          end

          # primary key
          if table.has_primary_key?
            column_names = table.primary_key.column_names
            if column_names.length == 1 && column_names.first == :id
              add_section "primary_key"
            else
              add_section "primary_key column_names: [:#{column_names.join(", :")}]"
            end
          end

          # common timestamp fields
          if table.has_column?(:created_at) && table.has_column?(:updated_at)
            add_section "core_timestamps"
          elsif table.has_column?(:created_at)
            add_section "core_timestamps, updated_at: false"
          elsif table.has_column?(:updated_at)
            add_section "core_timestamps, created_at: false"
          end

          # we process some columns specially, so we keep track of them here
          # so we can skip them later (code below can add to this list)
          skip_column_names = [:id, :created_at, :updated_at]

          # belongs_to associations
          table.foreign_key_constraints.each do |foreign_key_constraint|
            column_names = foreign_key_constraint.column_names

            # the columns for default (single column and predictable name) belongs_to associations
            # do not need to be represented as uuid fields, so we capture an array of those column
            # names here, so we can ignore them below
            if column_names.length == 1 && column_names.first == predictable_column_name_from_foreign_key_contraint(foreign_key_constraint)
              skip_column_names << column_names.first
            end

            add_belongs_to foreign_key_constraint
          end

          # has_many associations (coudl also be has_one, but we have no way to differentiate)
          table.remote_foreign_key_constraints.each do |foreign_key_constraint|
            add_has_many foreign_key_constraint
          end

          # action fields
          table.columns.each do |column|
            # if this looks like an action_field, then process it as such
            # look for a pair of columns like `published_at` and `unpublished`
            if column.name.end_with?("_at") && table.has_column?(:"un#{column.name[0..-4]}")
              # soft deletion has it's own dedicated method
              if column.name == :deleted_at
                add_section "soft_deletable"
              else
                add_section "action_field :#{column.name[0..-4]}, :#{column.name[0..-6]}"
              end

              # dont process these action fields again
              skip_column_names << column.name
              skip_column_names << :"un#{column.name[0..-4]}"
            end
          end

          # all other fields which have not already been processed
          table.columns.each do |column|
            # skip any columns which have already been processed
            next if skip_column_names.include? column.name

            add_field column
          end

          # validations which are not for a single column
          table.validations.each do |validation|
            # only pick validations which were not applied to a single column, because those
            # would already have been added above within the field definitions
            unless validation.columns.count == 1
              add_validation validation
            end
          end
        end

        private

        def predictable_column_name_from_foreign_key_contraint foreign_key_constraint
          :"#{foreign_key_constraint.foreign_table.name.to_s.singularize}_id"
        end

        def add_belongs_to foreign_key_constraint
          foreign_model_name = "#{foreign_key_constraint.foreign_table.schema.name.to_s.camelize}::#{foreign_key_constraint.foreign_table.name.to_s.camelize}"
          column_names = foreign_key_constraint.column_names
          foreign_column_names = foreign_key_constraint.foreign_column_names

          syntax = "belongs_to \"#{foreign_model_name}\""

          if column_names.length > 1 || column_names.first != predictable_column_name_from_foreign_key_contraint(foreign_key_constraint)
            syntax << ", local_column_names: [:#{column_names.join(", :")}]"
          end

          if foreign_column_names.length > 1 || foreign_column_names.first != :id
            syntax << ", foreign_column_names: [:#{foreign_column_names.join(", :")}]"
          end

          syntax << ", deferrable: true" if foreign_key_constraint.deferrable
          syntax << ", initially_deferred: true" if foreign_key_constraint.initially_deferred

          unless foreign_key_constraint.on_update == :no_action
            syntax << ", on_update: :#{foreign_key_constraint.on_update}"
          end

          unless foreign_key_constraint.on_delete == :no_action
            syntax << ", on_delete: :#{foreign_key_constraint.on_delete}"
          end

          # description comes last, so we can use HEREDOC syntax
          if foreign_key_constraint.has_description?
            syntax << ", " + <<~RUBY.strip
              comment: <<~DESCRIPTION
                #{word_wrap foreign_key_constraint.description, line_length: 80, indent: true}
              DESCRIPTION
            RUBY
          end

          add_section syntax
        end

        def add_has_many foreign_key_constraint
          # note that these are reversed from the `belongs_to` method above
          foreign_model_name = "#{foreign_key_constraint.table.schema.name.to_s.camelize}::#{foreign_key_constraint.table.name.to_s.camelize}"
          column_names = foreign_key_constraint.foreign_column_names
          foreign_column_names = foreign_key_constraint.column_names

          syntax = "has_many \"#{foreign_model_name}\""

          if column_names.length > 1 || column_names.first != :id
            syntax << ", local_column_names: [:#{column_names.join(", :")}]"
          end

          if foreign_column_names.length > 1 || foreign_column_names.first != predictable_column_name_from_foreign_key_contraint(foreign_key_constraint)
            syntax << ", foreign_column_names: [:#{foreign_column_names.join(", :")}]"
          end

          # description comes last, so we can use HEREDOC syntax
          if foreign_key_constraint.has_description?
            syntax << ", " + <<~RUBY.strip
              comment: <<~DESCRIPTION
                #{word_wrap foreign_key_constraint.description, line_length: 80, indent: true}
              DESCRIPTION
            RUBY
          end

          add_section syntax
        end

        # add the syntax for creating individual fields to the model
        def add_field column
          field_name = column.name

          default_value = default_value_syntax_from_column column

          field_method = if column.enum?
            :enum
          else
            field_method_name_from_column column
          end

          syntax = "#{field_method} :#{field_name}"

          # if this is an array column, then add the optional argument
          if column.array?
            syntax << ", array: true"
          end

          # so we can add any code which needs to be represented in a block, and easily determine
          # later if any code was actually added (determine if the block was even needed)
          block_lines = []

          # if there is a default value, then add it to the block
          if default_value
            block_lines << "default #{default_value}"
          end

          # if this column is nullable
          if column.null
            block_lines << "allow_null"
          end

          # add any validations
          column_validations(column).each do |validation|
            block_lines << validation
          end

          # if there is a description, then add it to the block
          if column.has_description?
            block_lines << <<~RUBY.strip
              description <<~DESCRIPTION
                #{word_wrap column.description, line_length: 80, indent: true}
              DESCRIPTION
            RUBY
          end

          # if anything was added to the block, then create a block and add it to the syntax
          if block_lines.any?
            syntax << " " + <<~RUBY
              do
                #{indent block_lines.join("\n\n")}
              end
            RUBY
          end

          add_section syntax
        end

        # add the syntax for creating individual validations to the model, this is used for
        # validations which cover multiple columns and would not have been picked up by the
        # `column_validations` method
        def add_validation validation
          # validations to ignore
          case validation.check_clause
          when /\(?\(\(\w+ IS TRUE\) AND \(\w+ IS NULL\)\) OR \(\(\w+ IS NULL\) AND \(\w+ IS NOT NULL\)\)\)?/
            # ignored because it is added automatically as part of the action_field definition

          else
            syntax = "add_validation :#{validation.name}"
            syntax << ", deferrable: true" if validation.deferrable
            syntax << ", initially_deferred: true" if validation.initially_deferred
            add_section syntax + ", " + <<~RUBY.strip
              <<~SQL
                #{validation.check_clause}
              SQL
            RUBY
          end
        end

        # process validations for a specific column (only validations which cover one
        # column are picked up here)
        def column_validations column
          validations = []

          column.table.validations.each do |validation|
            # the validation helper templates are only good for one column at a time
            # process each validation from this columns table, where the validation is
            # for only this column
            if validation.columns.count == 1 && validation.columns.first == column
              validations << case validation.check_clause
              when Databases::Migrations::Templates::Validations::EqualTo::VALUE_FROM_CHECK_CLAUSE
                "validate_equal_to \"#{$LAST_MATCH_INFO["value"]}\""

              when Databases::Migrations::Templates::Validations::Inclusion::VALUE_FROM_CHECK_CLAUSE
                "validate_in [#{$LAST_MATCH_INFO["value"]}]"

              when Databases::Migrations::Templates::Validations::Exclusion::VALUE_FROM_CHECK_CLAUSE
                "validate_not_in [#{$LAST_MATCH_INFO["value"]}]"

              when Databases::Migrations::Templates::Validations::Format::VALUE_FROM_CHECK_CLAUSE
                "validate_format /#{$LAST_MATCH_INFO["value"]}/"

              # an older version of the format validation template which included a null check
              when /\A\(?\("?\w+"?\s~\*\s'(?<value>.+)'(?:::citext)?\) OR \(\w+ IS NULL\)\)?\z/
                "validate_format /#{$LAST_MATCH_INFO["value"]}/"

              when Databases::Migrations::Templates::Validations::GreaterThanOrEqualTo::VALUE_FROM_CHECK_CLAUSE
                "validate_greater_than_or_equal_to #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::GreaterThan::VALUE_FROM_CHECK_CLAUSE
                "validate_greater_than #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::LessThanOrEqualTo::VALUE_FROM_CHECK_CLAUSE
                "validate_less_than_or_equal_to #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::LessThan::VALUE_FROM_CHECK_CLAUSE
                "validate_less_than #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::IsValue::VALUE_FROM_CHECK_CLAUSE
                "validate_is \"#{$LAST_MATCH_INFO["value"]}\""

              when Databases::Migrations::Templates::Validations::LengthIs::VALUE_FROM_CHECK_CLAUSE
                "validate_length_is #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::MaximumLength::VALUE_FROM_CHECK_CLAUSE
                "validate_maximum_length #{$LAST_MATCH_INFO["value"]}"

              when Databases::Migrations::Templates::Validations::MinimumLength::VALUE_FROM_CHECK_CLAUSE
                "validate_minimum_length #{$LAST_MATCH_INFO["value"]}"

              else

                syntax = "add_validation :#{validation.name}"
                syntax << ", deferrable: true" if validation.deferrable
                syntax << ", initially_deferred: true" if validation.initially_deferred
                syntax + ", " + <<~RUBY.strip
                  <<~SQL
                    #{validation.check_clause}
                  SQL
                RUBY
              end
            end
          end

          validations
        end

        # get the name of the platformer field method which is used for the given column
        def field_method_name_from_column column
          case column.base_data_type
          when :integer
            :integer_field
          when :bigint
            # todo
            :integer_field
          when :float
            :float_field
          when :text
            :text_field
          when :"character varying"
            # todo
            :text_field
          when :boolean
            :boolean_field
          when :citext
            (column.name == :email) ? :email_field : :citext_field
          when :uuid
            :uuid_field
          when :"timestamp without time zone"
            :datetime_field
          else
            raise UnexpectedColumnTypeError, "Unexpected column type `#{column.data_type}`"
          end
        end

        def default_value_syntax_from_column column
          unless column.default.nil?
            case column.base_data_type
            when :integer
              column.default
            when :bigint
              column.default
            when :float
              column.default
            when :text
              "\"#{column.default}\""
            when :"character varying"
              "\"#{column.default}\""
            when :boolean
              column.default
            when :citext
              "\"#{column.default}\""
            when :uuid
              "\"#{column.default}\""
            when :"timestamp without time zone"
              "\"#{column.default}\""
            else
              raise UnexpectedColumnTypeError, "Unexpected column type `#{column.data_type}`"
            end
          end
        end
      end
    end
  end
end
