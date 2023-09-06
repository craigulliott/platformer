# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::UniqueConstraints do
  describe "for a new UserModel which defines a simple new model numeric columns and each type of numeric validation" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer do
            unique
          end
          float_field :my_float do
            unique scope: :my_integer
          end
          numeric_field :my_numeric do
            unique scope: [:my_float, :my_integer], deferrable: true
          end
          double_field :my_double do
            unique comment: "Test description"
          end
          double_field :my_text do
            unique scope: [:my_float, :my_integer], where: "my_integer > 0"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected unique constraint for the DynamicMigrations table" do
      it { expect(subject.unique_constraint(:my_integer_uniq).column_names).to eql [:my_integer] }

      it { expect(subject.unique_constraint(:my_float_my_integer_uniq).deferrable).to be false }

      it { expect(subject.unique_constraint(:my_float_my_integer_uniq).column_names).to eql [:my_float, :my_integer] }

      it { expect(subject.unique_constraint(:my_numeric_my_float_my_integer_uniq).column_names).to eql [:my_numeric, :my_float, :my_integer] }

      it { expect(subject.unique_constraint(:my_numeric_my_float_my_integer_uniq).deferrable).to be true }

      it { expect(subject.unique_constraint(:my_double_uniq).column_names).to eql [:my_double] }

      it { expect(subject.unique_constraint(:my_double_uniq).description).to eq "Test description" }

      it { expect(subject.index(:my_text_my_float_my_integer_uniq).column_names).to eql [:my_text, :my_float, :my_integer] }

      it { expect(subject.index(:my_text_my_float_my_integer_uniq).where).to eq "my_integer > 0" }
    end
  end
end
