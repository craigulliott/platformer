module Platformer
  module DSLs
    module Models
      module InheritanceField
        def self.included klass
          klass.define_dsl :inheritance_field do
            description <<~DESCRIPTION
              Call this within your models to change the default field name which is used
              to display and set the type of a record when we are using inheritance. If
              inheritance is enabled for one of your models (by creating model classes which
              extend another model) and this method is not called then the default name "type"
              will be used.
            DESCRIPTION

            requires :name, :symbol do
              import_shared :snake_case_name_validator

              description <<~DESCRIPTION
                The name of this inherritance field, such as :role, :topic, :classification etc.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
