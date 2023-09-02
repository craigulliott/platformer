# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Email do
  describe "for a new UserModel which defines a simple new model with a email field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_email, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          email_field :my_email
        end
      end
    end

    subject {
      user = Users::User.new(my_email: "katy@socialkaty.com")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_email).to eq "katy@socialkaty.com" }
    end
  end
end
