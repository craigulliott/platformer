module Platformer
  module DSLs
    module Callbacks
      module AfterStageChange
        def self.included klass
          klass.define_dsl :after_stage_change do
            requires :to, :symbol
            optional :from, :symbol
          end
        end
      end
    end
  end
end
