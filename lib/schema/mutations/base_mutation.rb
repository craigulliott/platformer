module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def active_record_class
      self.class.instance_variable_get :@active_record_class
    end

    def self.active_record_class active_record_class
      @active_record_class = active_record_class
    end

    def create **attributes
      model = active_record_class.new(attributes)
      save model
    end

    def update model:, **attributes
      model.assign_attributes(attributes)
      save model
    end

    def save active_record_model
      if active_record_model.save
        # Successful. Return the created object with no errors
        {
          user: active_record_model,
          errors: []
        }
      else
        # Failed. Return the errors and a nil object
        {
          user: nil,
          errors: active_record_model.errors.map { |error|
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
