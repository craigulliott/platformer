# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Numeric do
  describe "for a new UserModel which defines a simple new model with a numeric field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_numeric, :numeric
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          numeric_field :my_numeric
        end
      end
    end

    subject {
      user = Users::User.new(my_numeric: 8.8)
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_numeric).to eq 8.8 }
    end
  end
end
