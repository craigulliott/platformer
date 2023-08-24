# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Functions
        module Validations
          class AssertArrayValuesTrimmedAndNullified < Function
            set_description <<~DESCRIPTION
              A function which will be called from a table trigger when changes are attempted to
              a column which contains an array of strings, and the corresponding field has a
              trimm_and_nullify coercion on it. This function takes an argument which corresponds to the
              column name, and will analyze the array in that column and assert that each value
              has been properly trimmed and that the array does not contain any empty strings.
            DESCRIPTION

            # checks the array values of all items in the colum specified by the provided argument
            # and raises an error if any of them haven't been trimmed and nullified
            set_definition <<~SQL
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
