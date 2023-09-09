module Mutations
  class UpdateMutation < BaseMutation
    class MissingActionNameError < StandardError
    end

    def self.persistence_method_name persistence_method_name
      @persistence_method_name = persistence_method_name
    end

    def resolve model:, **attributes
      model.assign_attributes(attributes)
      save model, persistence_method_name
    end

    private

    def persistence_method_name
      an = self.class.instance_variable_get :@persistence_method_name
      if an.nil?
        raise MissingActionNameError, "All update mutations require a persistence_method_name to be configured on the mutation class (such as :save, :publish, etc.)."
      end
      an
    end
  end
end
