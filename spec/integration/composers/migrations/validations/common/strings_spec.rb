# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Common::Strings do
  describe "for a new UserModel which defines a simple new model with string columns and each type of string validation" do
    before(:each) do
      scaffold do
        model_for "User" do
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
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it {
        expect(subject.validation(:my_char_min_len).check_clause).to eq <<~SQL.strip
          LENGTH(my_char) >= 1
        SQL
      }

      it {
        expect(subject.validation(:my_char_max_len).check_clause).to eq <<~SQL.strip
          LENGTH(my_char) <= 10
        SQL
      }

      it {
        expect(subject.validation(:my_char_not_in).check_clause).to eq <<~SQL.strip
          my_char NOT IN ('foo','bar')
        SQL
      }

      it {
        expect(subject.validation(:my_citext_length).check_clause).to eq <<~SQL.strip
          LENGTH(my_citext) = 5
        SQL
      }

      it {
        expect(subject.validation(:my_citext_format).check_clause).to eq <<~SQL.strip
          my_citext ~ '(?-mix:[a-z]+)'
        SQL
      }

      it {
        expect(subject.validation(:my_text_in).check_clause).to eq <<~SQL.strip
          my_text IN ('foo','bar')
        SQL
      }

      it {
        expect(subject.validation(:my_other_text_is).check_clause).to eq <<~SQL.strip
          my_other_text = 'exact value'
        SQL
      }
    end
  end
end
