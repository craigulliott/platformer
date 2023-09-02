# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Double do
  describe "for a new UserModel which defines a simple new model with a double field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_double, :"double precision"
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          double_field :my_double
        end
      end
    end

    subject {
      user = Users::User.new(my_double: 8.88)
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_double).to eq 8.88 }
    end
  end
end
