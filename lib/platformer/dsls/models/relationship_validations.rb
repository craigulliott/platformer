# #
# # Validations which use triggers (triggers are required if the conditions include other tables)
# #

# # raise an exceptions unless the conditions provided in the options return a valid record
# # this validation happens on inserts and updates
# def validate_exists table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is NOT EXISTS even though this method is validate_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_write table_name, scope_name, conditions: "#{options[:condition_prepend]} NOT EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_exists' above, except validation only happens on inserts
# def validate_exists_on_create table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is NOT EXISTS even though this method is validate_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_create table_name, scope_name, conditions: "#{options[:condition_prepend]} NOT EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_exists' above, except validation only happens on updates
# def validate_exists_on_update table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is NOT EXISTS even though this method is validate_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_update table_name, scope_name, conditions: "#{options[:condition_prepend]} NOT EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # raise an exception if the conditions provided in the options return a valid record
# # this validation happens on inserts and updates
# def validate_not_exists table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_write table_name, scope_name, conditions: "#{options[:condition_prepend]} EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # raise an exception if the conditions provided in the options return a valid record
# # this validation happens on inserts and updates
# def delayed_validate_not_exists table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   after_write table_name, scope_name, conditions: "#{options[:condition_prepend]} EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists' above, except validation only happens on inserts
# def validate_not_exists_on_create table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_create table_name, scope_name, conditions: "#{options[:condition_prepend]} EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists' above, except validation only happens on updates
# def validate_not_exists_on_update table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = options[:action] || "RAISE EXCEPTION 'validation #{scope_name} on this #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   before_update table_name, scope_name, conditions: "#{options[:condition_prepend]} EXISTS (#{block.call}) #{options[:condition_append]} ", when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists_on_update' above, except validation only happens when deleting (setting deleted_at)
# def validate_not_exists_on_delete table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = "RAISE EXCEPTION 'validation #{scope_name} marking deleted from #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   conditions = <<~CONDITIONS
#     OLD.deleted_at IS NULL
#     AND NEW.deleted_at IS NOT NULL
#     AND
#       #{options[:condition_prepend]}
#       EXISTS (#{block.call})
#       #{options[:condition_append]}
#   CONDITIONS

#   before_update table_name, scope_name, conditions: conditions, when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists_on_update' above, except validation only happens when deleting (setting published_at)
# def validate_not_exists_on_publish table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = "RAISE EXCEPTION 'validation #{scope_name} marking published from #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   conditions = <<~CONDITIONS
#     OLD.published_at IS NULL
#     AND NEW.published_at IS NOT NULL
#     AND
#       #{options[:condition_prepend]}
#       EXISTS (#{block.call})
#       #{options[:condition_append]}
#   CONDITIONS

#   before_update table_name, scope_name, conditions: conditions, when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists_on_delete' above, except validation only happens when undeleting (unsetting deleted_at)
# def validate_not_exists_on_undelete table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = "RAISE EXCEPTION 'validation #{scope_name} marking undeleted from #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   conditions = <<~CONDITIONS
#     OLD.deleted_at IS NOT NULL
#     AND NEW.deleted_at IS NULL
#     AND
#       #{options[:condition_prepend]}
#       EXISTS (#{block.call})
#       #{options[:condition_append]}
#   CONDITIONS

#   before_update table_name, scope_name, conditions: conditions, when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end

# # same as 'validate_not_exists_on_publish' above, except validation only happens when undeleting (unsetting published_at)
# def validate_not_exists_on_unpublish table_name, scope_name, options = {}, &block
#   # the action (which by default is to raise an exception) can be overridden with the action option
#   action = "RAISE EXCEPTION 'validation #{scope_name} marking unpublished from #{table_name} failed'"

#   # note, the SQL condition is EXISTS even though this method is validate_not_exists
#   # this is because we throw an exception when the SQL conditional passes true
#   # meaning, the validation actually passes when the condition returns false
#   conditions = <<~CONDITIONS
#     OLD.published_at IS NOT NULL
#     AND NEW.published_at IS NULL
#     AND
#       #{options[:condition_prepend]}
#       EXISTS (#{block.call})
#       #{options[:condition_append]}
#   CONDITIONS

#   before_update table_name, scope_name, conditions: conditions, when: options[:when] do
#     <<~SQL
#       #{action}
#     SQL
#   end
# end
