# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Currency do
  describe "for a new UserModel which defines a simple new model with a currency field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          currency_field
        end
        schema_for "Users::User" do
          fields [
            :currency_name
          ]
        end
      end
    end

    subject {
      Types::Users::User.fields["currencyName"]
    }

    context "creates the expected GraphQL Type class" do
      it { expect(subject).to be_a GraphQL::Schema::Field }

      it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

      it { expect(subject.type.of_type).to eq GraphQL::Types::String }
    end
  end
end
