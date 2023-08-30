# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::TrimAndNullify do
  describe "for a new UserModel which defines a simple new model, char column, array of chars column and a trim and nullify coercion" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        char_field :char_field do
          trim_and_nullify
        end
        char_field :array_of_chars_field, array: true do
          trim_and_nullify
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Char.rerun
      Platformer::Composers::Migrations::Coercions::Common::TrimAndNullify.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:char_field_trimmed_nullified).check_clause).to eq <<~SQL.strip
        char_field IS DISTINCT FROM '' AND REGEXP_REPLACE(REGEXP_REPLACE(char_field, '^ +', ''), ' +$', '') IS NOT DISTINCT FROM char_field
      SQL

      expect(table.trigger(:array_of_chars_field_trim_null_on_update).action_condition).to eq <<~SQL.strip
        NEW.array_of_chars_field IS DISTINCT FROM OLD.array_of_chars_field
      SQL
    end
  end
end
