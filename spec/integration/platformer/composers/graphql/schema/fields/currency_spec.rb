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
            :currency,
            :currency_name,
            :currency_code,
            :currency_symbol
          ]
        end
      end
    end

    context "the currency enum" do
      subject {
        Types::Users::User.fields["currency"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq Types::CurrencyEnum }
      end
    end

    context "the currency name" do
      subject {
        Types::Users::User.fields["currencyName"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "the currency code" do
      subject {
        Types::Users::User.fields["currencyCode"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "the currency symbol" do
      subject {
        Types::Users::User.fields["currencySymbol"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end
  end
end
