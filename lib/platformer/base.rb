module Platformer
  class Base
    class NoTableStructureForModelError < StandardError
    end

    class NoDatabaseForModelError < StandardError
    end

    class NoActiveRecordClassForModelError < StandardError
    end

    class UnexpectedBaseError < StandardError
    end

    class EquivilentClassDoesNotExistError < StandardError
    end

    include DSLCompose::Composer

    # base documentation for the models which inherit from this class
    def self.describe_class class_description
      @class_description = class_description
    end

    def self.class_description
      @class_description
    end

    # for swapping between classes, such as finding the Model class from it's
    # corresponding Schema class. If the corresponding model does not exist
    # then nil will be returned.
    warn "not tested"
    def self.get_equivilent_class target_base_class
      if target_base_class < self
        raise UnexpectedBaseError, "Refusing to to return the `#{target_base_class}` equivilent of this #{self}"
      end

      # the expected string at the end of the class name
      # unfortunately, we can not use a case statement to compare classes
      if target_base_class == ApplicationRecord
        target_append = ""
        namespace = ""

      elsif target_base_class == BaseModel
        target_append = "Model"
        namespace = ""

      elsif target_base_class == BaseSchema
        target_append = "Schema"
        namespace = ""

      elsif target_base_class == Types::BaseObject
        target_append = ""
        namespace = "Types::"

      else
        raise UnexpectedBaseError, "Unexpected base class `#{target_base_class}`"
      end

      # generate the expected class name based on the from_base and
      # setting the desired string at the end of the class name
      # unfortunately, we can not use a case statement to compare classes
      class_name = if self < BaseModel
        namespace + name.gsub(/Model\Z/, target_append)
      elsif self < BaseSchema
        namespace + name.gsub(/Schema\Z/, target_append)
      else
        raise UnexpectedBaseError, "Unexpected base class `#{self}`"
      end

      # if the constant exists, then return it, else return nil
      if Object.const_defined? class_name
        class_name&.constantize
      end
    end

    def self.callback_class
      get_equivilent_class BaseCallback
    end

    def self.job_class
      get_equivilent_class BaseJob
    end

    def self.model_class
      get_equivilent_class BaseModel
    end

    def self.mutation_class
      get_equivilent_class BaseMutation
    end

    def self.policy_class
      get_equivilent_class BasePolicy
    end

    def self.schema_class
      get_equivilent_class BaseSchema
    end

    def self.service_class
      get_equivilent_class BaseService
    end

    def self.subscription_class
      get_equivilent_class BaseSubscription
    end

    def self.active_record_class
      get_equivilent_class ApplicationRecord
    end

    def self.graphql_type_class
      get_equivilent_class Types::BaseObject
    end
  end
end
