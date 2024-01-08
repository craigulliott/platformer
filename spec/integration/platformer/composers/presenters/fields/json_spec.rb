# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Json do
  describe "for a new UserModel which defines a simple new model with a json field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_json, :jsonb
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          json_field :my_json
        end
      end
    end

    subject {
      user = Users::User.new(my_json: '{"name": "Yoshimi"}')
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_json).to eq '{"name": "Yoshimi"}' }
    end
  end
end
