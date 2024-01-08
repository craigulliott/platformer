module Platformer
  module Generators
    module FromGrape
      module APIs
        class BaseAPI < PlatformFile
          def initialize schema_name
            super :api, schema_name

            add_section "# this is the base class which all #{schema_name} API's should extend from"
          end
        end
      end
    end
  end
end
