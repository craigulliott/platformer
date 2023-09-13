# TODO

# these specs originally lived in Dynamic Migrations

# describe :validate_greater_than do
#   it "generates the expected sql for a templated check constraint" do
#     migration.validate_greater_than :my_table, :my_column, 0

#     expect(migration).to executed_sql <<~SQL
#       ALTER TABLE my_table
#         ADD CONSTRAINT my_column_gt
#           CHECK (my_column > 0)
#           NOT DEFERRABLE;
#     SQL
#   end
# end

# describe :validate_greater_than_or_equal_to do
#   it "generates the expected sql for a templated check constraint" do
#     migration.validate_greater_than_or_equal_to :my_table, :my_column, 0

#     expect(migration).to executed_sql <<~SQL
#       ALTER TABLE my_table
#         ADD CONSTRAINT my_column_gte
#           CHECK (my_column >= 0)
#           NOT DEFERRABLE;
#     SQL
#   end
# end

# describe :validate_less_than do
#   it "generates the expected sql for a templated check constraint" do
#     migration.validate_less_than :my_table, :my_column, 0

#     expect(migration).to executed_sql <<~SQL
#       ALTER TABLE my_table
#         ADD CONSTRAINT my_column_lt
#           CHECK (my_column < 0)
#           NOT DEFERRABLE;
#     SQL
#   end
# end

# describe :validate_less_than_or_equal_to do
#   it "generates the expected sql for a templated check constraint" do
#     migration.validate_less_than_or_equal_to :my_table, :my_column, 0

#     expect(migration).to executed_sql <<~SQL
#       ALTER TABLE my_table
#         ADD CONSTRAINT my_column_lte
#           CHECK (my_column <= 0)
#           NOT DEFERRABLE;
#     SQL
#   end
# end
