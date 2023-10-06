module Presenters
  class Base
    class PresenterMethodAlreadyExistsError < StandardError
    end

    def initialize model
      @model = model
    end

    def self.add_presenter name, &block
      if instance_methods.include?(name) && name != :object_id
        raise PresenterMethodAlreadyExistsError, "Method `#{name}` already exists for this `#{self.name}` presenter"
      end

      @presenter_method_names ||= []
      @presenter_method_names << name

      # if a block was not added, then assume the model
      # already has a method of the same name
      block ||= -> { model.send(name) }

      define_method name, &block
    end

    def self.presenter_methods
      @presenter_method_names
    end

    private

    attr_reader :model
  end
end
