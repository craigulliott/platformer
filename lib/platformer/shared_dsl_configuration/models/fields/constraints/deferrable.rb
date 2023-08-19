module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Constraints
            module Deferrable
              DSLCompose::SharedConfiguration.add :deferrable_constraint do
                optional :deferrable, :boolean do
                  description <<~DESCRIPTION
                    The enforcement of constraints occurs by default at the end of
                    each SQL statement. Setting `deferrable: true` allows you to
                    customize this behaviour and optionally enforce the unique
                    constraint at the end of a transaction instead of after each
                    statement.
                  DESCRIPTION
                end

                optional :initially_deferred, :boolean do
                  description <<~DESCRIPTION
                    If true, then the default time to check the constraint will
                    be at the end of the transaction rather than at the end of
                    each statement.

                    Setting `initially_deferred: true` requires that this
                    constraint is also marked as `deferrable: true`.
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
