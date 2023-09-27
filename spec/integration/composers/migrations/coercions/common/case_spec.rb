# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::Case do
  describe "for a new UserModel which defines a simple new model, text and char columns and each type of case coercion" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :uppercase_text_field do
            uppercase
          end
          text_field :lowercase_text_field do
            lowercase
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it {
        expect(subject.validation(:uppercase_text_field_uppercase_only).check_clause).to eq <<~SQL.strip
          uppercase_text_field IS NOT DISTINCT FROM upper(uppercase_text_field)
        SQL
      }

      it {
        expect(subject.validation(:lowercase_text_field_lowercase_only).check_clause).to eq <<~SQL.strip
          lowercase_text_field IS NOT DISTINCT FROM lower(lowercase_text_field)
        SQL
      }
    end
  end

  describe "for a new UserModel which defines a simple new model, array of text and array of char columns and each type of case coercion" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :uppercase_text_field, array: true do
            uppercase
          end
          text_field :lowercase_text_field, array: true do
            lowercase
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it {
        expect(subject.validation(:uppercase_text_field_uppercase_only).check_clause).to eq <<~SQL.strip
          uppercase_text_field IS NULL OR upper(ARRAY_REMOVE(uppercase_text_field, NULL)::text) IS NOT DISTINCT FROM ARRAY_REMOVE(uppercase_text_field, NULL)::text
        SQL
      }

      it {
        expect(subject.validation(:lowercase_text_field_lowercase_only).check_clause).to eq <<~SQL.strip
          lowercase_text_field IS NULL OR lower(ARRAY_REMOVE(lowercase_text_field, NULL)::text) IS NOT DISTINCT FROM ARRAY_REMOVE(lowercase_text_field, NULL)::text
        SQL
      }
    end
  end
end
