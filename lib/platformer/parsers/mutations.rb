module Platformer
  module Parsers
    # Process the parser for every final descendant of BaseMutation.
    class Mutations < ClassParser
      base_class BaseMutation
      final_child_classes_only true

      class << self
        alias_method :for_final_mutations, :for_base_class
        alias_method :for_dsl, :dsl_for_base_class
      end
    end
  end
end
