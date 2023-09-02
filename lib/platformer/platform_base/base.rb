module Platformer
  class Base
    class UnexpectedBaseError < StandardError
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

      elsif target_base_class == BaseCallback
        target_append = "Callback"
        namespace = ""

      elsif target_base_class == BaseJob
        target_append = "Job"
        namespace = ""

      elsif target_base_class == BaseModel
        target_append = "Model"
        namespace = ""

      elsif target_base_class == BaseMutation
        target_append = "Mutation"
        namespace = ""

      elsif target_base_class == BasePolicy
        target_append = "Policy"
        namespace = ""

      elsif target_base_class == BasePresenter
        target_append = "Presenter"
        namespace = ""

      elsif target_base_class == BaseSchema
        target_append = "Schema"
        namespace = ""

      elsif target_base_class == BaseService
        target_append = "Service"
        namespace = ""

      elsif target_base_class == BaseSubscription
        target_append = "Subscription"
        namespace = ""

      elsif target_base_class == Types::BaseObject
        target_append = ""
        namespace = "Types::"

      elsif target_base_class == Presenters::Base
        target_append = ""
        namespace = "Presenters::"

      else
        raise UnexpectedBaseError, "Unexpected base class `#{target_base_class}`"
      end

      # generate the expected class name based on the from_base and
      # setting the desired string at the end of the class name
      # unfortunately, we can not use a case statement to compare classes
      class_name = if self < BaseCallback
        namespace + name.gsub(/Callback\Z/, target_append)

      elsif self < BaseJob
        namespace + name.gsub(/Job\Z/, target_append)

      elsif self < BaseModel
        namespace + name.gsub(/Model\Z/, target_append)

      elsif self < BaseMutation
        namespace + name.gsub(/Mutation\Z/, target_append)

      elsif self < BasePolicy
        namespace + name.gsub(/Policy\Z/, target_append)

      elsif self < BasePresenter
        namespace + name.gsub(/Presenter\Z/, target_append)

      elsif self < BaseSchema
        namespace + name.gsub(/Schema\Z/, target_append)

      elsif self < BaseService
        namespace + name.gsub(/Service\Z/, target_append)

      elsif self < BaseSubscription
        namespace + name.gsub(/Subscription\Z/, target_append)

      # Types::BaseObject and Presenters::Base are not listed here
      # because those classes do not extend from this class

      else
        raise UnexpectedBaseError, "Unexpected base class `#{self}`"
      end

      # if the constant exists, then return it, else return nil
      if Object.const_defined? class_name
        class_name&.constantize
      end
    end

    # callback_definition_classes
    def self.callback_definition_class
      get_equivilent_class BaseCallback
    end

    # job_definition_classes
    def self.job_definition_class
      get_equivilent_class BaseJob
    end

    # model_definition_classes
    def self.model_definition_class
      get_equivilent_class BaseModel
    end

    # mutation_definition_classes
    def self.mutation_definition_class
      get_equivilent_class BaseMutation
    end

    # policy_definition_classes
    def self.policy_definition_class
      get_equivilent_class BasePolicy
    end

    # presenter_definition_classes
    def self.presenter_definition_class
      get_equivilent_class BasePresenter
    end

    # schema_definition_classes
    def self.schema_definition_class
      get_equivilent_class BaseSchema
    end

    # service_definition_classes
    def self.service_definition_class
      get_equivilent_class BaseService
    end

    # subscription_definition_classes
    def self.subscription_definition_class
      get_equivilent_class BaseSubscription
    end

    # active_record_classes
    def self.active_record_class
      get_equivilent_class ApplicationRecord
    end

    # graphql_type_classes
    def self.graphql_type_class
      get_equivilent_class Types::BaseObject
    end

    # presenter_classes
    def self.presenter_class
      get_equivilent_class Presenters::Base
    end
  end
end
