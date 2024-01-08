module Platformer
  module DSLs
    module APIs
      module Fields
        def self.included klass
          klass.define_dsl :fields do
            description <<~DESCRIPTION
              A list of the all this models scalar and enum fields which will be exposed via JSONAPI.
            DESCRIPTION

            requires :fields, :symbol, array: true do
              import_shared :snake_case_name_validator

              description <<~DESCRIPTION
                The names of this models fields to expose.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
