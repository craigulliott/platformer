# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Text do
  describe "for a new UserModel which defines a simple new model with a text field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text
        end
        api_for "Users::User" do
          fields [
            :my_text
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_text }
    end
  end
end
