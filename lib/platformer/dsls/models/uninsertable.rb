# prevent inserting a new record when conditions are not met, most commonly to prevent
# inserting data when a related record has been marked as deleted
# usage:
# uninsertable_row :bars, {
#   name: 'override the name used for the function and trigger',
#   scope_name: :deleted_foo, # used in the generation of a name
#   conditions: <<~SQL
#     ( SELECT
#         deleted_at IS NULL
#         FROM foos.foos
#         WHERE id = NEW.foo_id
#     ) IS FALSE
#   SQL,
#   message: 'can not insert this new bar because the provided foo has been deleted'
# }
#
# alternative usage for predefined options (see def common_uninsertable_options below)
# uninsertable_row :bars, if: :deleted_foo
