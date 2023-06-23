# frozen_string_literal: true

module Platformer
  module Composers
    class CreateActiveModels < Composer
      # Dynamically create ActiveRecord classes to represent each
      # of our model definitions.
      #
      # For example, if we have have created a UserModel and an
      # OrganizationModel, then this composer will generate a `User`
      # and an `Organization` class, these new classes will extend
      # ActiveRecord::Base
      for_each_child_class ApplicationModel do |klass|
        # for a model class with an optional namespace, such as
        # Users::UserModel, returns an array ['Users', 'User']
        class_address = klass.name.gsub(/Model\Z/, "").split("::")
        # the last item in the address is the new class name
        class_name = class_address.pop
        # where is this new class being created
        namespace = if class_address.any?
          # any remaining items describe the namespace
          class_address.join("::").constantize
        else
          # Object is the top most namespace
          Object
        end

        new_class = Class.new(ActiveRecord::Base)
        namespace.const_set class_name, new_class
      end

      for_each ApplicationModel, :string_field do |klass, name|
      end
    end
  end
end
