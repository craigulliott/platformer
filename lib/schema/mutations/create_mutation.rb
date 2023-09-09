module Mutations
  class CreateMutation < BaseMutation
    class MissingActiveRecordClassError < StandardError
    end

    def self.active_record_class active_record_class
      @active_record_class = active_record_class
    end

    def resolve **attributes
      model = active_record_class.new(attributes)
      save model, :save
    end

    private

    def active_record_class
      arc = self.class.instance_variable_get :@active_record_class
      if arc.nil?
        raise MissingActiveRecordClassError, "Create mutations require an active_record_class to be configured on the mutation class"
      end
      arc
    end
  end
end
