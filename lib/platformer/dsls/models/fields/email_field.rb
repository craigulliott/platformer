module Platformer
  module DSLs
    module Models
      module Fields
        module EmailField
          def self.included klass
            klass.define_dsl :email_field do
              description "Add an email field to this model."
            end
          end
        end
      end
    end
  end
end
