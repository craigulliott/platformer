# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Float do
  describe "for a new UserModel which defines a simple new model with a float field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          float_field :my_float
        end
        schema_for "Users::User" do
          fields [
            :my_float
          ]
        end
      end
    end

    subject {
      Types::Users::User.fields["myFloat"]
    }

    context "creates the expected GraphQL Type class" do
      it { expect(subject).to be_a GraphQL::Schema::Field }

      it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

      it { expect(subject.type.of_type).to eq GraphQL::Types::Float }
    end
  end
end
