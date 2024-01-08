# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Currency do
  describe "for a new UserModel which defines a simple new model with a currency field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          currency_field
        end
        api_for "Users::User" do
          fields [
            :currency,
            :currency_name,
            :currency_code,
            :currency_symbol
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "currency" do
      it { expect(subject).to have_key :currency }
    end

    context "currency_name" do
      it { expect(subject).to have_key :currency_name }
    end

    context "currency_code" do
      it { expect(subject).to have_key :currency_code }
    end

    context "currency_symbol" do
      it { expect(subject).to have_key :currency_symbol }
    end
  end
end
