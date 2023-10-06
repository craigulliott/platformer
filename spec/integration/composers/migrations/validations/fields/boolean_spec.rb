# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Fields::Boolean do
  describe "for a new UserModel which defines a simple new model, boolean columns and each type of numeric validation" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          boolean_field :my_bool do
            # no special validations
          end
          boolean_field :my_false_bool do
            validate_is_false
          end
          boolean_field :my_true_bool do
            validate_is_true
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it { expect(subject.validation(:my_false_bool_is_false).check_clause).to eq "my_false_bool IS FALSE" }

      it { expect(subject.validation(:my_true_bool_is_true).check_clause).to eq "my_true_bool IS TRUE" }
    end
  end
end
