module Platformer
  module Parsers
    # Process the parser for every descendant of BaseModel, which includes
    # models in the class hierarchy that may be abstract and lack a corresponding
    # database table. This class hierarchy adheres to the ActiveRecord convention,
    # which makes this parser the preferred method for parsing our models and generating
    # the relevant business logic for ActiveRecord models.
    #
    # Importantly, the models returned by this parser are not guaranteed to be final
    # models in the class hierarchy, and therefore may not have a corresponding table
    # in the database.
    #
    # This parser returns every model but will only execute the provided block for DSLs
    # specifically invoked on that actual model, ignoring DSLs called on its ancestors.
    # In contrast, the FinalModels parser yields only for classes at the end of the class
    # hierarchy, yet executes the block for DSLs called on any class within that models class
    # hierarchy.
    class AllModels < ClassParser
      base_class BaseModel
      final_child_classes_only false

      class << self
        alias_method :for_models, :for_base_class
        alias_method :for_dsl, :dsl_for_base_class
      end
    end
  end
end
