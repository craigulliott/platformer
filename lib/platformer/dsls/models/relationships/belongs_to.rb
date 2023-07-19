module Platformer
  module DSLs
    module Models
      module Relationships
        module BelongsTo
          def self.included klass
            klass.define_dsl :belongs_to do
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
