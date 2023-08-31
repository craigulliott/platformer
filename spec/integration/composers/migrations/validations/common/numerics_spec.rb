# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Common::Numerics do
  describe "for a new UserModel which defines a simple new model with numeric columns and each type of numeric validation" do
    before(:each) do
      scaffold do
        model_for "User" do
          database :postgres, :primary
          integer_field :my_integer do
            validate_greater_than 0
          end
          float_field :my_float do
            validate_greater_than_or_equal_to 0
          end
          numeric_field :my_numeric do
            validate_less_than 10
          end
          double_field :my_double do
            validate_less_than_or_equal_to 10
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected validations for the DynamicMigrations table" do
      it { expect(subject.has_validation?(:my_integer_gt)).to be true }

      it { expect(subject.has_validation?(:my_float_gte)).to be true }

      it { expect(subject.has_validation?(:my_numeric_lt)).to be true }

      it { expect(subject.has_validation?(:my_double_lte)).to be true }
    end
  end
end
