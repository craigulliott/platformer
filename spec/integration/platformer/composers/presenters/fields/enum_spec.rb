# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Enum do
  describe "for a new UserModel which defines a simple new model with a enum field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_enum, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          enum_field :my_enum, ["foo", "bar"]
        end
      end
    end

    subject {
      user = Users::User.new(my_enum: "foo")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_enum).to eq "foo" }
    end
  end
end
