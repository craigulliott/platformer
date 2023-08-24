# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Common::Strings do
  describe "for a new UserModel which defines a simple new model with string columns and each type of string validation" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        char_field :my_char do
          validate_minimum_length 1
          validate_maximum_length 10
          validate_not_in ["foo", "bar"]
        end
        citext_field :my_citext do
          validate_length_is 5
          validate_format(/[a-z]+/)
        end
        text_field :my_text do
          validate_in ["foo", "bar"]
        end
        text_field :my_other_text do
          validate_is_value "exact value"
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::CharColumns.rerun
      Platformer::Composers::Migrations::Columns::CitextColumns.rerun
      Platformer::Composers::Migrations::Columns::TextColumns.rerun
      Platformer::Composers::Migrations::Validations::Common::Strings.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:my_char_min_len).check_clause).to eq <<~SQL.strip
        LENGTH(my_char) >= 1
      SQL

      expect(table.validation(:my_char_max_len).check_clause).to eq <<~SQL.strip
        LENGTH(my_char) <= 10
      SQL

      expect(table.validation(:my_char_not_in).check_clause).to eq <<~SQL.strip
        my_char NOT IN ('foo'::text,'bar'::text)
      SQL

      expect(table.validation(:my_citext_length).check_clause).to eq <<~SQL.strip
        LENGTH(my_citext) = 5
      SQL

      expect(table.validation(:my_citext_format).check_clause).to eq <<~SQL.strip
        my_citext ~ '(?-mix:[a-z]+)'
      SQL

      expect(table.validation(:my_text_in).check_clause).to eq <<~SQL.strip
        my_text IN ('foo'::text,'bar'::text)
      SQL

      expect(table.validation(:my_other_text_is).check_clause).to eq <<~SQL.strip
        my_other_text = 'exact value'
      SQL
    end
  end
end
