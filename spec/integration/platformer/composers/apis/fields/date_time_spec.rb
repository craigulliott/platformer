# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::DateTime do
  describe "for a new UserModel which defines a simple new model with a date_time field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_time_field :my_date_time
        end
        api_for "Users::User" do
          fields [
            :my_date_time
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_date_time }
    end
  end
end
