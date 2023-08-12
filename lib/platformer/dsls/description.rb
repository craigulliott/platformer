module Platformer
  module DSLs
    module Description
      def self.included klass
        klass.define_dsl :description do
          description <<~DESCRIPTION
            Add descriptions to your classes.
          DESCRIPTION

          requires :description, :string do
            description <<~DESCRIPTION
              The description to add. This accepts markdown.
            DESCRIPTION
          end
        end
      end
    end
  end
end
