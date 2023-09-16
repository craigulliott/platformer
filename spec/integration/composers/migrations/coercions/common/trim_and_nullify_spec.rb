# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::TrimAndNullify do
  describe "for a new UserModel which defines a simple new model, char column, array of chars column and a trim and nullify coercion" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          char_field :char_field do
            trim_and_nullify
          end
          char_field :array_of_chars_field, array: true do
            trim_and_nullify
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it {
        expect(subject.validation(:char_field_trimmed_nullified).check_clause).to eq <<~SQL.strip
          char_field IS DISTINCT FROM '' AND REGEXP_REPLACE(REGEXP_REPLACE(char_field, '^ +', ''), ' +$', '') IS NOT DISTINCT FROM char_field
        SQL
      }

      it {
        expect(subject.trigger(:array_of_chars_field_trim_null_on_update).action_condition).to eq <<~SQL.strip
          NEW.array_of_chars_field IS DISTINCT FROM OLD.array_of_chars_field AND NEW.array_of_chars_field IS NOT NULL
        SQL
      }
    end
  end
end
