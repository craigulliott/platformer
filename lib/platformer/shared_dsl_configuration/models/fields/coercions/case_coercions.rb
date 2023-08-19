module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Coercions
            module CaseCoercions
              DSLCompose::SharedConfiguration.add :case_coercions do
                add_unique_method :lowercase do
                  description <<~DESCRIPTION
                    Ensures that the value of this field is a lowercase string.
                    If it contains uppercase letters, then it will be converted automatically
                    to lowercase. This coercion logic will be installed into active record. A
                    validation will also be added to the underlying postgres table to ensure
                    that there are no uppercase letters.
                  DESCRIPTION

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for enforcing lowercase
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end

                add_unique_method :uppercase do
                  description <<~DESCRIPTION
                    Ensures that the value of this field is an uppercase string.
                    If it contains lowercase letters, then it will be converted automatically
                    to uppercase. This coercion logic will be installed into active record. A
                    validation will also be added to the underlying postgres table to ensure
                    that there are no lowercase letters.
                  DESCRIPTION

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for enforcing uppercase
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
