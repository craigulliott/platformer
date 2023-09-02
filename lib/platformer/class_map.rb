module Platformer
  module ClassMap
    class ClassAlreadyExistsError < StandardError
    end

    # Returns an array of classes which directly subclass the provided class
    def self.subclasses base_class
      base_class.subclasses.filter { |subclass| class_is_still_defined? subclass }
    end

    # Returns true if there are any classes which directly subclass the provided
    # class, otherwise returns false
    def self.has_subclasses? base_class
      base_class.subclasses.filter { |subclass| class_is_still_defined? subclass }.any?
    end

    # Returns true if no classes directly subclass the provided class,
    # otherwise returns false
    def self.no_subclasses? base_class
      has_subclasses?(base_class) == false
    end

    # Create a class with the provided name.
    #
    # If the class name is namespaced, then the desirec namespace will be created
    # automatically (by dynamically creating modules).
    #
    # If a block is provided, then the block will be evaluated within the class
    # immediately after the class has been named and places into the expected module.
    def self.create_class full_name, base_class, &block
      # Fail loudly if this class already exists
      if Object.const_defined? full_name
        raise ClassAlreadyExistsError, "class `#{full_name}` already exists"
      end

      # Create a new anonymous class which extends the provided base class. This
      # class will be named and placed into the expected module below.
      new_class = Class.new(base_class)

      # Find (or create) the module which matches the namespace from the provided full name
      # If there was no namespace, then this will just return Object, which is rubys top most level.
      namespace = namespace_from_class_name full_name
      # Intall the new class with the expected name, into the expected constant
      class_name = full_name.split("::").last
      namespace.const_set class_name, new_class

      # If one was provided, then yield the block to perform any custom setup for this
      # new class.
      if block
        new_class.class_eval(&block)
      end

      # return our newly created class
      new_class
    end

    # This is used because subclasses can still be returned after they have been destroyed, but not yet
    # garbage collected. This method is safe to use in this scenario, it returns the expected
    # value even if the garbage collection has not occured yet.
    def self.class_is_still_defined? klass
      Object.const_defined?(klass.name) && Object.const_get(klass.name).equal?(klass)
    end

    # Provided with a class name such as "Foo::Bar" or "Foo", return the constant which
    # represents the namespace for this class. If the constant does not exist, then it will
    # be created automatically. If there is no namespace, then Object will be returned, as this
    # is ruby's top most object.
    def self.namespace_from_class_name name
      # Split a class name into an array of strings, where each item in the array represents one
      # one part of the classes hierachy, but not the class name itself.
      #
      # For example, if the class was "Users::Admin", then the resulting array would be ["Users"]
      # if the class was "Aaa::Bbb::Ccc", then the resulting array would be ["Aaa", "Bbb"]
      namespace_parts = name.split("::")[0..-2]
      # if the model was namespaced, then recombine the parts and return the constant
      if namespace_parts.any?
        # if a base was provided, then make sure each part of the namespace
        # exists under this base, and create it if needed
        position = Object
        progressive_name = ""
        namespace_parts.each do |namespace|
          progressive_name << "::#{namespace}"
          position = Object.const_defined?(progressive_name) ? Object.const_get(progressive_name) : position.const_set(namespace, Module.new)
        end
        # the value of position is now the final namespace, so return it
        position
      else
        # Object is the top most namespace
        Object
      end
    end
  end
end
