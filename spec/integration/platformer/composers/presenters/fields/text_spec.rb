# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Text do
  describe "for a new UserModel which defines a simple new model with a text field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_text, :text
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          text_field :my_text
        end
      end
    end

    subject {
      user = Users::User.new(my_text: "Hi Katy!")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_text).to eq "Hi Katy!" }
    end
  end
end
