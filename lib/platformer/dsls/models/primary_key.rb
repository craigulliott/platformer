module Platformer
  module DSLs
    module Models
      module PrimaryKey
        def self.included klass
          klass.define_dsl :primary_key do
            description <<~DESCRIPTION
              Add a primary key to this table.
            DESCRIPTION

            optional :skip, :boolean do
              description <<~DESCRIPTION
                If skip is true, then the primary key will not be added to this model.
                This is useful if you are vcalling `primary_key` somewhere like
                `PlatformModel` because you want to add it to most of your models, but
                then wish to override that for a specific model which inherits from
                `PlatformModel`.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
