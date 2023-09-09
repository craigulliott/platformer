module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    class MissingNodeNameError < StandardError
    end

    class MissingPresenterClassError < StandardError
    end

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    # errors as data: https://graphql-ruby.org/mutations/mutation_errors.html#errors-as-data
    field :errors, [Types::ValidationError], null: false

    def self.node_name node_name
      @node_name = node_name
    end

    def self.presenter_class presenter_class
      @presenter_class = presenter_class
    end

    private

    def node_name
      nn = self.class.instance_variable_get :@node_name
      if nn.nil?
        raise MissingNodeNameError, "Mutations require an node_name to be configured on the mutation class"
      end
      nn
    end

    def presenter_class
      pc = self.class.instance_variable_get :@presenter_class
      if pc.nil?
        raise MissingPresenterClassError, "Mutations require a presenter_class to be configured on the mutation class"
      end
      pc
    end

    def save active_record_model, method_name = :save
      if active_record_model.public_send(method_name)
        # Successful. Return the created object with no errors
        {
          node_name => presenter_class.new(active_record_model),
          :errors => []
        }
      else
        # Failed. Return the errors and a nil object
        {
          node_name => nil,
          :errors => active_record_model.errors.map { |error|
            {
              path: ["attributes", error.attribute.to_s.camelize(:lower)],
              message: error.message
            }
          }
        }
      end
    end
  end
end
