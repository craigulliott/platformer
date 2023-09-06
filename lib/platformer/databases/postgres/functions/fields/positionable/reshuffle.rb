# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      module Functions
        module Fields
          module Positionable
            class Reshuffle < Function
              set_description <<~DESCRIPTION
              DESCRIPTION

              set_definition <<~SQL
                DECLARE
                BEGIN
                  RETURN NEW;
                END;
              SQL
            end
          end
        end
      end
    end
  end
end
