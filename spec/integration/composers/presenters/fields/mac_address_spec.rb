# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::MacAddress do
  describe "for a new UserModel which defines a simple new model with a mac_address field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_mac_address, :macaddr
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          mac_address_field :my_mac_address
        end
      end
    end

    subject {
      user = Users::User.new(my_mac_address: "58-50-4A-2E-29-AB")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_mac_address).to eq "58-50-4A-2E-29-AB" }
    end
  end
end
