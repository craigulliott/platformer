module Platformer
  module DSLs
    module Models
      module CoreTimestamps
        def self.included klass
          klass.define_dsl :core_timestamps do
            description <<~DESCRIPTION
              Add the automatically managed `updated_at` and `created_at` timestamps
              to this model. By default, both will be added.
            DESCRIPTION

            optional :created_at, :boolean do
              description <<~DESCRIPTION
                Set to false to ommit the created_at timestamp
              DESCRIPTION
            end

            optional :updated_at, :boolean do
              description <<~DESCRIPTION
                Set to false to ommit the updated_at timestamp
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
