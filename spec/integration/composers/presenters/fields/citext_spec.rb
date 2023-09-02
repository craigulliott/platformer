# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Citext do
  describe "for a new UserModel which defines a simple new model with a citext field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_citext, :citext
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          citext_field :my_citext
        end
      end
    end

    subject {
      user = Users::User.new(my_citext: "Hi Katy!")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_citext).to eq "Hi Katy!" }
    end
  end
end
