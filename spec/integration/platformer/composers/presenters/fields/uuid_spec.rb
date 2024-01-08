# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Uuid do
  describe "for a new UserModel which defines a simple new model with a uuid field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_uuid, :uuid
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          uuid_field :my_uuid
        end
      end
    end

    subject {
      user = Users::User.new(my_uuid: "63510e31-bbf8-49e0-9878-ce2a974ead54")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_uuid).to eq "63510e31-bbf8-49e0-9878-ce2a974ead54" }
    end
  end
end
