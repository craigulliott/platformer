# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::DateTime do
  describe "for a new UserModel which defines a simple new model with a date_time field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_time_field :my_date_time
        end
        schema_for "Users::User" do
          fields [
            :my_date_time
          ]
        end
      end
    end

    subject {
      Types::Users::User.fields["myDateTime"]
    }

    context "creates the expected GraphQL Type class" do
      it { expect(subject).to be_a GraphQL::Schema::Field }

      it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

      it { expect(subject.type.of_type).to eq GraphQL::Types::ISO8601DateTime }
    end
  end
end
