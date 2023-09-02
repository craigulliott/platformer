# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::PhoneNumber do
  describe "for a new UserModel which defines a simple new model with a phone_number field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :dialing_code, :char
          add_column :phone_number, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          phone_number_field
        end
      end
    end

    subject {
      user = Users::User.new(dialing_code: "1", phone_number: "0123456789")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.dialing_code).to eq "1" }

      it { expect(subject.phone_number).to eq "0123456789" }

      it { expect(subject.phone_number_formatted).to eq "(012) 345-6789" }

      it { expect(subject.phone_number_international_formatted).to eq "+1 (012) 345-6789" }
    end
  end
end
