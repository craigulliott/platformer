module Platformer
  module DSLs
    module Models
      module Fields
        module EnumField
          def self.included klass
            klass.define_dsl :enum_field do
              description "Add an enum field to this model."
            end
          end
        end
      end
    end
  end
end
