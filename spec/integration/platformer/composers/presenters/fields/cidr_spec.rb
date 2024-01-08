# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Cidr do
  describe "for a new UserModel which defines a simple new model with a cidr field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_cidr, :cidr
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          cidr_field :my_cidr
        end
      end
    end

    subject {
      user = Users::User.new(my_cidr: "10.0.0.0/8")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_cidr).to eq "10.0.0.0/8" }
    end
  end
end
