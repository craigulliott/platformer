module Platformer
  module Generators
    module FromDatabase
      module Models
        warn "not tested"
        class Model < PlatformFile
          class UnexpectedColumnTypeError < StandardError
          end

          def initialize table
            super :model, table.schema.name, table.name

            # we process some columns specially, so we keep track of them here
            # so we can skip them later (code below can add to this list)
            skip_column_names = [:id, :created_at, :updated_at]

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
              add_section "core_timestamps updated_at: false"
            elsif table.has_column?(:updated_at)
              add_section "core_timestamps created_at: false"
            end

            # position column
            if table.has_column?(:position) && table.column(:position).data_type == :integer
              add_section "positionable"
              skip_column_names << :position
            end

            # skip the longitude and latitude if we have a lonlat
            if table.has_column?(:lonlat) && table.has_column?(:longitude)
              skip_column_names << :longitude
            end
            if table.has_column?(:lonlat) && table.has_column?(:latitude)
              skip_column_names << :latitude
            end

            # phone_number columns
            {
              phone_number: :dialing_code,
              from_phone_number: :from_dialing_code,
              to_phone_number: :to_dialing_code
            }.each do |phone_number_col, dialing_code_col|
              if table.has_column?(phone_number_col) && table.has_column?(dialing_code_col)
                syntax = "phone_number_field"
                if phone_number_col.start_with? "to_"
                  syntax << " prefix: :to"
                elsif phone_number_col.start_with? "from_"
                  syntax << " prefix: :from"
                end
                if table.column(phone_number_col).null
                  syntax << " do\n  allow_null\nend"
                end
                skip_column_names << phone_number_col
                skip_column_names << dialing_code_col
              end
            end

            # add all our associations
            if (associations = ASSOCIATIONS[:"#{module_name}::#{class_name}"])
              associations[:belongs_to]&.each do |name, options|
                add_association :belongs_to, name, options

                # the columns for belongs_to associations do not need to be
                # represented as uuid fields, so we add them to the ignore list here
                skip_column_names << :"{name}_id"
              end
              associations[:has_many]&.each do |name, options|
                add_association :has_many, name, options
              end
              associations[:has_one]&.each do |name, options|
                add_association :has_one, name, options
              end
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
                  add_section "action_field :#{column.name[0..-4]}, action_name: :#{column.name[0..-6]}"
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

            # validations which were not applied to a specific field
            table.validations.each do |validation|
              # only pick validations which were not applied to a single column and had their own
              # template, because those would already have been added above within the field definitions
              unless validation.columns.count == 1 && validation_template_from_check_clause(validation.check_clause)
                add_validation validation
              end
            end
          end

          private

          def predictable_column_name_from_foreign_key_contraint foreign_key_constraint
            :"#{foreign_key_constraint.foreign_table.name.to_s.singularize}_id"
          end

          def add_association type, name, options
            syntax = ""

            if options[:has_lambda]
              syntax << "# TODO: this association originally had a lambda:\n"
            end

            syntax << "#{type} :#{name}"

            if options[:through]
              syntax << ", through: :#{options[:through]}"
            end

            if options[:class_name]
              syntax << ", model: \"#{options[:class_name]}Model\""
            end

            if options[:foreign_key]
              syntax << ", foreign_columns: :#{options[:foreign_key]}"
            end

            if options[:primary_key]
              syntax << ", local_columns: :#{options[:primary_key]}"
            end

            add_section syntax
          end

          # add the syntax for creating individual fields to the model
          def add_field column
            field_name = column.name

            # so we can add any code which needs to be represented in a block, and easily determine
            # later if any code was actually added (determine if the block was even needed)
            block_lines = []

            # build this up below
            syntax = ""

            if column.enum?
              if column.name == :time_zone
                syntax << "time_zone_field"

              elsif column.name == :country
                syntax << "country_field"

              elsif column.name == :language
                syntax << "language_field"

              elsif column.name == :currency_iso_code
                syntax << "currency_field"

              else
                # the enum
                # Display is a reserved word, its a standard lib ruby method. Change the enum from MissionStepInsertableModel
                # and MissionStepModel from `display` to `display_type`
                field_name = :display_type if field_name == :display
                syntax << "enum_field :#{field_name}"

                # add the enum values
                syntax << ", [\n  '#{column.enum.values.join("',\n  '")}'\n]"
              end

            else
              case column.base_data_type
              when :boolean
                syntax << "boolean_field :#{field_name}"

              when :integer
                syntax << "integer_field :#{field_name}"

              when :bigint
                syntax << "integer_field :#{field_name}, bigint: true"

              when :float
                syntax << "float_field :#{field_name}"

              # default numeric (without precision and scale)
              when :numeric
                syntax << "numeric_field :#{field_name}"

              # numeric with precision and scale
              when /\Anumeric\((?<precision>\d+),(?<scale>\d+)\)\z/
                syntax << "numeric_field :#{field_name}, precision: #{$LAST_MATCH_INFO["precision"]}, scale: #{$LAST_MATCH_INFO["scale"]}"

              when :text
                syntax << "text_field :#{field_name}"

              # default character varying (no length)
              when :"character varying"
                syntax << "text_field :#{field_name}"

              # character varying with a max length
              when /\Acharacter varying(?:\((?<length>\d+)\))?\z/
                syntax << "text_field :#{field_name}"
                unless $LAST_MATCH_INFO["length"].nil?
                  block_lines << "validate_maximum_length #{$LAST_MATCH_INFO["length"]}"
                end

              when /\Acharacter\((?<length>\d+)\)\z/
                syntax << "text_field :#{field_name}"
                block_lines << "validate_length_is #{$LAST_MATCH_INFO["length"]}"

              when :citext
                syntax << ((column.name == :email) ? "email_field" : "citext_field :#{field_name}")

              when :uuid
                syntax << "uuid_field :#{field_name}"

              when :"timestamp without time zone"
                syntax << "date_time_field :#{field_name}"

              when :date
                syntax << "date_field :#{field_name}"

              when :inet
                syntax << "ip_address_field :#{field_name}"

              when :cidr
                syntax << "cidr_field :#{field_name}"

              when :macaddr
                syntax << "mac_address_field :#{field_name}"

              when :json
                syntax << "json_field :#{field_name}"

              when :"postgis.geography(Point,4326)"
                syntax << ((column.name == :lonlat) ? "geo_point_field" : "geo_point_field :#{field_name}")

              else
                raise UnexpectedColumnTypeError, "Unexpected column type `#{column.data_type}`"
              end

            end

            # if this column is nullable
            if column.null
              # add a comma if there has alredy been at least one argument
              syntax << "," if / /.match?(syntax)
              syntax << " allow_null: true"
            end

            # if this is an array column, then add the optional argument
            if column.array?
              # add a comma if there has alredy been at least one argument
              syntax << "," if / /.match?(syntax)
              syntax << " array: true"
            end

            unless column.default.nil?
              # boolen true and false can be presented as scalars
              if column.default == "true" || column.default == "false"
                block_lines << "default #{column.default}"
                block_lines << "\"database_default #{column.default}\""

              # numbers can be presented as scalars (positive or negative numbers, with optional decimal points)
              elsif column.default.match?(/\A-?\d+(\.\d+)?\z/)
                block_lines << "default #{column.default}"
                block_lines << "\"database_default #{column.default}\""

              # everything else is presented as a string
              else
                "database_default \"#{column.default.tr('"', '\"')}\""
              end
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
          # `column_validations` method or validations which do not have a template
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
                # if there is a template, then we can add the validation inside this field, otherwise
                # it needs to be added to the model (not be nested in a field)
                if (template = validation_template_from_check_clause validation.check_clause)
                  validations << template
                end
              end
            end

            validations
          end

          def validation_template_from_check_clause check_clause
            case check_clause
            when Databases::Migrations::Templates::Validations::EqualTo::VALUE_FROM_CHECK_CLAUSE
              "validate_equal_to \"#{$LAST_MATCH_INFO["value"]}\""

            when Databases::Migrations::Templates::Validations::Inclusion::VALUE_FROM_CHECK_CLAUSE
              "validate_in [#{$LAST_MATCH_INFO["value"]}]"

            when Databases::Migrations::Templates::Validations::Exclusion::VALUE_FROM_CHECK_CLAUSE
              "validate_not_in [#{$LAST_MATCH_INFO["value"]}]"

            when Databases::Migrations::Templates::Validations::Format::VALUE_FROM_CHECK_CLAUSE
              # switch ^ and $ with \A and \z (because activerecord complains about them as a security concern)
              final_regex = $LAST_MATCH_INFO["value"].gsub(/\A\^/, '\A').gsub(/\$\z/, '\z')
              "validate_format /#{final_regex}/"

            # an older version of the format validation template which included a null check
            when /\A\(?\("?\w+"?\s~\*\s'(?<value>.+)'(?:::citext)?\) OR \(\w+ IS NULL\)\)?\z/
              # switch ^ and $ with \A and \z (because activerecord complains about them as a security concern)
              final_regex = $LAST_MATCH_INFO["value"].gsub(/\A\^/, '\A').gsub(/\$\z/, '\z')
              "validate_format /#{final_regex}/"

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
            end
          end

          # get the name of the platformer field method which is used for the given column
          def field_method_name_from_column column
          end
        end
      end
    end
  end
end
