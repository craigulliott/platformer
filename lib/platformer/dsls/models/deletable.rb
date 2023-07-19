module Platformer
  module DSLs
    module Models
      module Deletable
        def self.included klass
          klass.define_dsl :audit_log do
            description <<-DESCRIPTION
              When used on a model definition, this method will allow the model
              to be soft deleted. Soft deletable models have `undeleted` (null | true)
              and `deleted_at` (null | timestamp) columns in their associated postgres
              table.

              When a model is soft deleted, it will have its deleted_at set to
              the current time and undeleted will be set to null. Models which have not
              been deleted will have deleted_at=null and undeleted=true.

              Various convenience methods, postgres constraints and the installation of
              new active record callbacks will also be created for soft deletable models
            DESCRIPTION

            optional :undeletable, :boolean do
              description <<-DESCRIPTION
                If set to true, then mechanisms and permissions will be added which allow
                soft deletable models to be undeleted
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
