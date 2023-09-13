module Platformer
  module LoadTasks
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    warn "not tested"
    module ClassMethods
      def load_tasks
        Dir[File.expand_path("tasks/**/*.rake", __dir__)].each do |f|
          load f
        end
      end
    end
  end
end
