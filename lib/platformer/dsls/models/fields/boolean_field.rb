module Platformer
  module DSLs
    module Models
      module Fields
        module BooleanField
          def self.included klass
            klass.define_dsl :boolean_field do
              description "Add an boolean field to this model."
            end
          end
        end
      end
    end
  end
end
