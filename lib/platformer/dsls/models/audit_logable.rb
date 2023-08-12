module Platformer
  module DSLs
    module Models
      module AuditLogable
        def self.included klass
          klass.define_dsl :audit_log do
            description <<~DESCRIPTION
              When used on a model definition, this method will ensure
              all changes to the models postgres table will be logged
              in a the postgres audit table
            DESCRIPTION
          end
        end
      end
    end
  end
end
