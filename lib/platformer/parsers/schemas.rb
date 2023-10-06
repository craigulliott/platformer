module Platformer
  module Parsers
    # Process the parser for every final descendant of BaseSchema.
    class Schemas < ClassParser
      base_class BaseSchema
      final_child_classes_only true

      class << self
        alias_method :for_schemas, :for_base_class
        alias_method :for_dsl, :dsl_for_base_class
      end
    end
  end
end
