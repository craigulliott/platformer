# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Integer do
  describe "for a new UserModel which defines a simple new model with a integer field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_integer, :integer
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          integer_field :my_integer
        end
      end
    end

    subject {
      user = Users::User.new(my_integer: 123)
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_integer).to eq 123 }
    end
  end
end
