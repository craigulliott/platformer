module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          module ImmutableFunctionDefinition
            # if immutable_once_set is true, then the additional condition of
            # 'OLD.column_name IS NOT NULL' is added
            def self.definition immutable_once_set = false
              <<~SQL
                -- The actual assertation that immutable columns have not changed happens
                -- in the trigger. The function is just responsible for building and raising
                -- an exception.
                DECLARE
                  array_populating_queries_string TEXT;
                  immutable_columns_which_changed TEXT[];
                BEGIN
                  -- Where TG_ARGV is all the column names (provided to this function as args) which
                  -- should be immutable.
                  -- build and execute a query which will return a string that looks something like..
                  -- "(SELECT 'col_name' WHERE OLD.col_name != NEW.col_name), (SELECT 'next_col_name' WHERE OLD.next_col_name != NEW.next_col_name)"
                  -- this will be used below to build an array of column names which have changed
                  -- by executing another query which uses the SQL "ARRAY[array_populating_queries_string]"
                  EXECUTE '
                    SELECT ARRAY_TO_STRING(
                      ARRAY_AGG(
                        statements.select_sql
                      ), '', '')
                    FROM (
                      SELECT
                        CONCAT(''(SELECT '''''', col_name, '''''' WHERE $1.'', col_name, '' IS DISTINCT FROM $2.'', col_name, '' ${immutable_once_set ? " AND $1.'', col_name, '' IS NOT NULL" : ""})'') as select_sql
                      FROM
                      UNNEST(ARRAY[''' || ARRAY_TO_STRING(TG_ARGV, ''',''') || ''']) AS col_name
                    ) AS statements
                  '
                  -- the resulting string is placed in array_populating_queries_string
                  INTO array_populating_queries_string USING OLD, NEW;

                  -- execute another query which takes the string from the previous step and builds
                  -- an array containing only the column names which had changes
                  EXECUTE '
                    SELECT ARRAY_REMOVE(ARRAY[' || array_populating_queries_string || '], NULL)
                  '
                  -- store the array of column names (the names of immutable columns which have changes)
                  INTO immutable_columns_which_changed USING OLD, NEW;

                  -- raise an exception which includes the names of columns for which changes were forbidden
                  RAISE EXCEPTION
                    'trigger %: updating is prohibited for %',
                    tg_name, ARRAY_TO_STRING(immutable_columns_which_changed, ', ')
                  USING
                    ERRCODE = 'restrict_violation';
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
