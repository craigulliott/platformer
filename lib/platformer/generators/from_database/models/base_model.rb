module Platformer
  module Generators
    module FromDatabase
      module Models
        warn "not tested"
        class BaseModel < PlatformFile
          def initialize schema
            super :model, schema.name

            add_section "# this is the base class which all #{schema.name} models should extend from"

            add_section <<~RUBY
              # all models in this schema will be stored in the "#{schema.name}" posgres schema
              schema :#{schema.name}
            RUBY
          end
        end
      end
    end
  end
end
