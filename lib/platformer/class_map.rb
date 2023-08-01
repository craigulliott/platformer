module Platformer
  module ClassMap
    class ClassDoesNotExtendError < StandardError
    end

    class ApplicationRecordAlreadyExistsError < StandardError
    end

    class ActiveRecordClassAlreadyCreatedError < StandardError
    end

    class ActiveRecordClassDoesNotExistError < StandardError
    end

    # Returns true is `provided_class` is extended from `base_class`
    # otherwise raises an error
    def self.validate_class_extends! provided_class, base_class
      if provided_class < base_class
        true
      else
        raise ClassDoesNotExtendError, "Unexpected class #{provided_class}. Was expecting a class which extends from #{base_class}"
      end
    end

    warn "not tested"
    def self.subclasses base_class
      base_class.subclasses.filter { |subclass| class_is_still_defined? subclass }
    end

    warn "not tested"
    def self.has_subclasses? base_class
      base_class.subclasses.filter { |subclass| class_is_still_defined? subclass }.any?
    end

    warn "not tested"
    def self.no_subclasses? base_class
      has_subclasses?(base_class) == false
    end

    warn "not tested"
    def self.class_is_still_defined? klass
      Object.const_defined?(klass.name) && Object.const_get(klass.name).equal?(klass)
    end

    # Returns the constant representing the namespace of the provided class.  If the provided
    # class is not namespaced, then `Object` (ruby's top most namespace) is returned.
    #
    # For example. If the provided class was `Foo::Bar`, then the constant `Foo` would be
    # returned. If the provided class was `Foo`, then the constant `Object` would be returned.
    def self.namespace_from_class provided_class
      # Split a class name into an array of strings, where each item in the array represents one
      # one part of the classes hierachy, but not the class name itself.
      #
      # For example, if the class was "Users::Admin", then the resulting array would be ["Users"]
      # if the class was "Aaa::Bbb::Ccc", then the resulting array would be ["Aaa", "Bbb"]
      namespace_parts = provided_class.name.split("::")[0..-2]
      # if the model was namespaced, then recombine the parts and return the constant
      if namespace_parts.any?
        namespace_parts.join("::").constantize
      else
        # Object is the top most namespace
        Object
      end
    end

    # When provided with a model class, this will return the ActiveRecord
    # class of the Model classes direct ansestor.
    #
    # For example...
    #
    # class UsersModel < PlatformModel
    #   # note, because this class has descendents, it will also be
    #   # automatically created as an abstract class
    # end
    #
    # class AdminModel < UsersModel
    # end
    #
    # With the model class hieracy above, the following results will be returned
    #   `base_application_record_class AdminModel` will return `Users`
    #   `base_application_record_class UsersModel` will return `ApplicationRecord`
    def self.base_application_record_class model_class
      # if there is no namespace, then just return ApplicationRecord
      if model_class.ancestors[1] == PlatformModel
        ApplicationRecord

      else
        # return the active_record class which was already created for this
        # models direct ancestor
        get_active_record_class_from_model_class model_class.ancestors[1]
      end
    end

    warn "not tested"
    def self.active_record_class_name_from_model_class model_class
      model_class.name.split("::").last.gsub(/Model\Z/, "")
    end

    warn "not tested"
    def self.active_record_table_name_from_model_class model_class
      active_record_class_name_from_model_class(model_class).underscore.pluralize.to_sym
    end

    # Provided with a model definition class, will create and return a valid
    # active record model. If the active record model already exists then an
    # error is raised
    #
    # For example, when provided with Users::UserModel this will create and
    # return the corresponding Users::User (which will subclass Users::UsersRecord)
    def self.create_active_record_class_from_model_class model_class, &block
      # assert that the provided class is a subclass of PlatformModel
      validate_class_extends! model_class, PlatformModel

      class_name = active_record_class_name_from_model_class model_class

      new_class = Class.new(base_application_record_class(model_class))
      namespace = namespace_from_class model_class

      # assert the class has not already been created
      if namespace.const_defined? class_name
        raise ActiveRecordClassAlreadyCreatedError, "Active record class `#{class_name}` already exists"
      end

      namespace.const_set class_name, new_class

      if block
        new_class.class_eval(&block)
      end

      new_class
    end

    # Provided with a model definition class, will return the corresponding
    # active record model. If the active record model does not already exists
    # then an error is raised
    #
    # For example, will return Users::User from Users::UserModel
    def self.get_active_record_class_from_model_class model_class
      # assert that the provided class is a subclass of PlatformModel
      validate_class_extends! model_class, PlatformModel
      # remove "Model" from the end of the class name, and then convert
      # the string into a constant
      class_name = model_class.name.gsub(/Model\Z/, "")

      # assert the class already exists
      unless Object.const_defined? class_name
        raise ActiveRecordClassDoesNotExistError, "Active record class `#{class_name}` does not exist"
      end

      # turn the class name into a constant, and return it
      class_name.constantize
    end
  end
end
