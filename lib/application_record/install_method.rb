module Platformer
  module ActiveRecord
    module InstallMethod
      extend ActiveSupport::Concern

      class MethodAlreadyExistsError < StandardError
      end

      module ClassMethods
        def install_method method_name, &method_body
          # dont allow us to override existing methods
          # this method is called from within our composers system where lots of methods
          # are defined dynamically, and overidding methods is likely to have unexpected
          # consiquences
          if respond_to? method_name
            raise MethodAlreadyExistsError, "The method `#{method_name}` already exists on this `#{name}`."
          end

          # add the method to the class
          define_method method_name, &method_body
        end
      end
    end
  end
end
