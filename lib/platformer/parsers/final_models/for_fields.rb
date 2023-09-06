module Platformer
  module Parsers
    # A convenience wrapper for the FinalModels parser which simplifies
    # parsing field DSLs
    class FinalModels
      class ForFields < FinalModels
        include ForFieldMacros

        class << self
          alias_method :for_fields, :for_dsl
        end

        resolve_argument :allow_null do |reader:|
          reader.method_called?(:allow_null)
        end

        resolve_argument :comment_text do |reader:|
          reader.comment&.comment
        end

        resolve_argument :default do |reader:|
          reader.default&.default
        end

        resolve_argument :column_name do |dsl_execution:|
          DSLReaders::Models::Field.new(dsl_execution).column_name
        end

        resolve_argument :column_names do |dsl_execution:|
          DSLReaders::Models::Field.new(dsl_execution).column_names
        end
      end
    end
  end
end
