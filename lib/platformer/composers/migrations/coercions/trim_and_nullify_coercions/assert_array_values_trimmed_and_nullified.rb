module Platformer
  module Composers
    module Migrations
      module Coercions
        class TrimAndNullifyCoercions < DSLCompose::Parser
          module AssertArrayValuesTrimmedAndNullified
            # checks the array values of all items in the colum specified by the provided argument
            # and raises an error if any of them haven't been trimmed and nullified
            def self.definition
              <<~SQL
                -- checks the array values of all items in the array column specified by the provided argument
                -- and raises an error if any of them were not trimmed and nullified prior to saving
                DECLARE
                  column_name TEXT = TG_ARGV[0];
                  invalid_values TEXT[];
                BEGIN
                  -- select all values which
                  EXECUTE '
                    SELECT
                      ARRAY_AGG(n)
                    FROM UNNEST($1.' || column_name || ') AS n
                    WHERE
                      REGEXP_REPLACE(REGEXP_REPLACE(n, ''^\s+'', ''''), ''\s+$'', '''') IS DISTINCT FROM n
                      OR REGEXP_REPLACE(REGEXP_REPLACE(n, ''^\s+'', ''''), ''\s+$'', '''') IS NOT DISTINCT FROM ''''
                      ;
                  '
                  -- the resulting illegal values are placed in invalid_values
                  INTO invalid_values USING NEW;

                  -- raise an exception which includes the illegal values
                  IF invalid_values IS NOT NULL THEN
                    RAISE EXCEPTION
                      'trigger %: attempted values have not been trimmed or nullified: "%"',
                      tg_name, ARRAY_TO_STRING(invalid_values, '", "')
                    USING
                      ERRCODE = 'restrict_violation';
                  END IF;
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
