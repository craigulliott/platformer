module Platformer
  module Root
    class RootNotSetError < StandardError
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    warn "not tested"
    module ClassMethods
      def root relative_path = nil
        if ENV["PLATFORMER_ROOT"].nil?
          raise RootNotSetError, "Root is not set. Call `Platformer::Root.set_root` in your platform's `config/boot.rb` file"
        end
        File.expand_path relative_path, ENV["PLATFORMER_ROOT"]
      end
    end
  end
end
