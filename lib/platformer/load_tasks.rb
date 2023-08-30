module Platformer
  module LoadTasks
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    warn "not tested"
    module ClassMethods
      def load_tasks
        Dir[File.expand_path(File.dirname(__FILE__) + "/tasks/**/*.rake")].each do |f|
          load f
        end
      end
    end
  end
end
