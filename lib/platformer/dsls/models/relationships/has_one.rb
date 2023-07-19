module Platformer
  module DSLs
    module Models
      module Relationships
        module HasOne
          def self.included klass
            klass.define_dsl :has_one do
              requires :name, :class do
                description <<-DESCRIPTION
                  todo
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
