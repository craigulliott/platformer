module Platformer
  module DSLs
    module Models
      module AddValidation
        def self.included klass
          klass.define_dsl :add_validation do
            description <<~DESCRIPTION
              Add a custom validation to this model.
            DESCRIPTION

            requires :name, :symbol do
              import_shared :snake_case_name_validator

              description <<~DESCRIPTION
                A name for the check clause.
              DESCRIPTION
            end

            requires :check_clause, :string do
              description <<~DESCRIPTION
                The SQL check clause for this validation, such as `age >= 21`.
              DESCRIPTION
            end

            # add `deferrable: boolean` and `initially_deferred: boolean` options
            import_shared :deferrable_constraint

            optional :description, :string do
              description <<~DESCRIPTION
                A description which explains the reason for this validation
                on this field. This will be used to generate documentation,
                and will be added as a description to the database constraint.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
