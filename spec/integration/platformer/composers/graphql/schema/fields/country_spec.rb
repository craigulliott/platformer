# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Country do
  describe "for a new UserModel which defines a simple new model with a country field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field
        end
        schema_for "Users::User" do
          fields [
            :country,
            :country_code,
            :country_alpha3_code,
            :country_name,
            :country_full_name,
            :country_subregion,
            :country_continent
          ]
        end
      end
    end

    context "country enum" do
      subject {
        Types::Users::User.fields["country"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq Types::CountryEnum }
      end
    end

    context "country code" do
      subject {
        Types::Users::User.fields["countryCode"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "country alpha3 code" do
      subject {
        Types::Users::User.fields["countryAlpha3Code"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "country name" do
      subject {
        Types::Users::User.fields["countryName"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "country full name" do
      subject {
        Types::Users::User.fields["countryFullName"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "country subregion" do
      subject {
        Types::Users::User.fields["countrySubregion"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "country continent" do
      subject {
        Types::Users::User.fields["countryContinent"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end
  end
end
