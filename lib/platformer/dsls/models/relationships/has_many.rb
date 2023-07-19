module Platformer
  module DSLs
    module Models
      module Relationships
        module HasMany
          def self.included klass
            klass.define_dsl :has_many do
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
