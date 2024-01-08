# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Boolean do
  describe "for a new UserModel which defines a simple new model with a boolean field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_boolean, :boolean
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          boolean_field :my_boolean
        end
      end
    end

    subject {
      user = Users::User.new(my_boolean: true)
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_boolean).to eq true }
    end
  end
end
