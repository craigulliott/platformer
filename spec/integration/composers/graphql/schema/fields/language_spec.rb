# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Language do
  describe "for a new UserModel which defines a simple new model with a language field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field
        end
        schema_for "Users::User" do
          fields [
            :language_name,
            :language_code
          ]
        end
      end
    end

    context "the language name" do
      subject {
        Types::Users::User.fields["languageName"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq GraphQL::Types::String }
      end
    end

    context "the language code" do
      subject {
        Types::Users::User.fields["languageCode"]
      }

      context "creates the expected GraphQL Type class" do
        it { expect(subject).to be_a GraphQL::Schema::Field }

        it { expect(subject.type).to be_a GraphQL::Schema::NonNull }

        it { expect(subject.type.of_type).to eq Types::LanguageCodeEnum }
      end
    end
  end
end
