# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Char do
  describe "for a new UserModel which defines a simple new model with a char field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_char, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          char_field :my_char
        end
      end
    end

    subject {
      user = Users::User.new(my_char: "Hi Katy!")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_char).to eq "Hi Katy!" }
    end
  end
end
