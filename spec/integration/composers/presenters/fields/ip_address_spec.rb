# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::IpAddress do
  describe "for a new UserModel which defines a simple new model with a ip_address field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_ip_address, :inet
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          ip_address_field :my_ip_address
        end
      end
    end

    subject {
      user = Users::User.new(my_ip_address: "192.168.0.1")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_ip_address).to eq "192.168.0.1" }
    end
  end
end
