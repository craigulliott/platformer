# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::TimeZone do
  describe "for a new UserModel which defines a simple new model with a time_zone field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          time_zone_field
        end
        schema_for "Users::User" do
          fields [
            :time_zone,
            :time_zone_name,
            :time_zone_identifier
          ]
        end
      end
    end

    context "the time_zone" do
      subject {
        Types::Users::User.fields["timeZone"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq Types::TimeZoneEnum }
      end
    end

    context "the time_zone name" do
      subject {
        Types::Users::User.fields["timeZoneName"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "the time_zone identifier" do
      subject {
        Types::Users::User.fields["timeZoneIdentifier"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end
  end
end
