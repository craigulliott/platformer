module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    # Override #initialize to take a new argument:
    def initialize(*args, active_record_model_class: nil, arguments_metadata: nil, **kwargs, &block)
      @active_record_model_class = active_record_model_class
      @arguments_metadata = arguments_metadata
      # Pass on the default args:
      super(*args, **kwargs, &block)
    end

    attr_reader :active_record_model_class
    attr_reader :arguments_metadata
  end
end
