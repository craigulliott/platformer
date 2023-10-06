module Platformer
  class Base
    class UnexpectedBaseError < StandardError
    end

    class PlatformClassNamingConventionError < StandardError
    end

    class InvalidModelClassNameError < StandardError
    end

    class NotStiClassError < StandardError
    end

    include DSLCompose::Composer

    # All platform definition files which live within the /platform folder must follow these
    # strict naming and class hierachy conventions. For simplicity, only models are shown here
    # but in reality each schema will also have other definition files for things like policies,
    # services graphql mutations etc.
    #
    # platform/
    # ├─ billing/
    # │  ├─ billing_model.rb      # `module Billing ... class BillingModel < PlatformModel`
    # │  ├─ models/
    # │  │  ├─ subscription.rb    # `module Billing ... SubscriptionModel < BillingModel`
    # │  │  ├─ credit_card.rb     # `module Billing ... CreditCardModel < BillingModel`
    # ├─ users/
    # │  ├─ users_model.rb        # `module Users ... UsersModel < PlatformModel`
    # │  ├─ models/
    # │  │  ├─ user.rb            # `module Users ... UserModel < UsersModel`
    # ├─ communication/
    # │  ├─ text_message.rb       # `module Communication ... TextMessageModel < PlatformModel`
    # │  ├─ text_messages/
    # │  |  ├─ auth.rb            # an STI model : `module Communication::TextMessages ... AuthModel < TextMessageModel`
    # │  |  ├─ welcome.rb         # an STI model : `module Communication::TextMessages ... WelcomeModel < TextMessageModel`
    def self.validate_naming_and_hierachy_conventions subclass, type
      # assert the subclass name ends with the expected type ('Model', 'Policy', 'Callback' etc.)
      unless subclass.name.end_with? type
        raise InvalidModelClassNameError, "#{type} class names must end with '#{type}'"
      end

      case subclass.name
      # The base class for all classes of this type within the platform, this should directly extend the internal platformer
      # class of the expected type. For example, `PlatformModel` should directly extend `Platformer::BaseModel`
      when /\APlatform#{type}\z/
        if subclass.ancestors[1].name != "Platformer::Base#{type}"
          raise PlatformClassNamingConventionError, "Invalid class hierachy. `#{subclass.name}` should directly extend `Platformer::Base#{type}`."
        end

      # All other classes must be namespaced
      when /\A[a-zA-Z0-9]+\z/
        raise PlatformClassNamingConventionError, "Invalid class name/hierachy. `#{subclass.name}` should be namespaced (placed within a module)."

      # Classes which are within a single namespace (one level deep), such as `Users::UserModel`
      when /\A(?<schema_name>[a-zA-Z0-9]+)::(?:[a-zA-Z0-9]+)\z/
        schema_name = $LAST_MATCH_INFO["schema_name"]

        # Each schema should have a dedicated class of each type which all other classes of this type will extend from.
        # For example, the users schema should have a class named `Users::UserModel` which extends `PlatformModel`, all models
        # within the users schema must then extend from this `Users::UserModel`
        #
        # If the subclass is this base class.
        if subclass.name == "#{schema_name}::#{schema_name}#{type}"
          # Assert that this subclass directly extends the expected base class. I.e. assert that `Users::UserModel`
          # directly extends `PlatformModel`
          unless subclass.ancestors[1].name == "Platform#{type}"
            raise PlatformClassNamingConventionError, "Invalid class hierachy. The special base class `#{subclass.name}` must extend `Platform#{type}`."
          end

        # If this subclass is not the base class
        elsif subclass.ancestors[1].name != "#{schema_name}::#{schema_name}#{type}"
          # Assert that the subclass extends from the base class. I.e. assert that `Users::AvatarModel` extends from `Users::UserModel`
          raise PlatformClassNamingConventionError, "Invalid class hierachy `#{subclass.name}`. All #{type} classes within the #{schema_name} schema must directly extend `#{schema_name}::#{schema_name}#{type}`."
        end

      # Classes which are namespaced by two levels (two levels deep), such as `Communication::TextMessages::WelcomeModel`. These
      # classes are automatically assumed to be STI models (single table innheritance)
      when /\A(?<schema_name>[a-zA-Z0-9]+)::(?<sti_namespace>[a-zA-Z0-9]+)::(?:[a-zA-Z0-9]+)\z/
        schema_name = $LAST_MATCH_INFO["schema_name"]
        sti_namespace = $LAST_MATCH_INFO["sti_namespace"]

        # STI classes which are represented by a namepacing of three levels must directly extend a base class of the expected name.
        # For example, `Communication::TextMessages::WelcomeModel` should directly extend from the base class `Communication::TextMessageModel`.
        unless subclass.ancestors[1].name == "#{schema_name}::#{sti_namespace.singularize}Model"
          raise PlatformClassNamingConventionError, "Invalid class hierachy. Expected STI class `#{subclass.name}` to be an ancestor of `#{schema_name}::#{sti_namespace.singularize}Model`."
        end

      # Assert that the subclass extends from

      # classes which do not fit any of the patterns above (such as having 4 levels of namepacing) are not valid
      else
        raise PlatformClassNamingConventionError, "Unexpected class name `#{subclass.name}`. Please refer to the documentation about class hierachy and naming conventions."
      end

      # the type of definition file this is, such as 'Model', 'Policy', 'Callback' etc.
      subclass
    end

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
      class_name = namespace + name.gsub(/#{base_type}\Z/, target_append)

      # if the constant exists, then return it, else return nil
      if Object.const_defined? class_name
        class_name&.constantize
      end
    end

    def self.base_type
      if self < BaseCallback
        "Callback"

      elsif self < BaseJob
        "Job"

      elsif self < BaseModel
        "Model"

      elsif self < BaseMutation
        "Mutation"

      elsif self < BasePolicy
        "Policy"

      elsif self < BasePresenter
        "Presenter"

      elsif self < BaseSchema
        "Schema"

      elsif self < BaseService
        "Service"

      elsif self < BaseSubscription
        "Subscription"

      else
        raise UnexpectedBaseError, "Unexpected base class `#{self}`"
      end
    end

    # is this an STI class?
    # sti classes are namespaced with 3 parts, such as `Communication::TextMessages:WelcomeModel`
    def self.sti_class?
      name.split("::").count == 3
    end

    # get the base class for an sti class
    # if this class is a `Communication::TextMessages:WelcomeModel` then this
    # method will return the constant `Communication::TextMessageModel`
    def self.sti_base_class
      namespace_parts = name.split("::")
      unless namespace_parts.count == 3
        raise NotStiClassError, "This `#{self}` is not an STI class (sti classes are namespaced with 3 parts, such as `Communication::TextMessages:WelcomeModel`)"
      end
      # return the expected constant
      "#{namespace_parts[0]}::#{namespace_parts[1].singularize}#{base_type}".constantize
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
