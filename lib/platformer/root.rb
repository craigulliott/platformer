module Platformer
  module Root
    class RootNotSetError < StandardError
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def root relative_path = nil
        if ENV["PLATFORMER_ROOT"].nil?
          raise RootNotSetError, "Root is not set. Set the PLATFORMER_ROOT environemnt variable or add a value for ENV['PLATFORMER_ROOT'] in your platform's `config/boot.rb` file"
        end
        File.expand_path relative_path, ENV["PLATFORMER_ROOT"]
      end
    end
  end
end
