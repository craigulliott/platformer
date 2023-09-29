# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Currency do
  describe "for a new UserModel which defines a simple new model with a currency field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :currency, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          currency_field
        end
      end
    end

    subject {
      user = Users::User.new(currency: "CURRENCY_USD")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.currency_name).to eq "United States Dollar" }

      it { expect(subject.currency_code).to eq "USD" }
    end
  end
end
