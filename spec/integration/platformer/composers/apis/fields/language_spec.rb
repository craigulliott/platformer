# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Language do
  describe "for a new UserModel which defines a simple new model with a language field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field
        end
        api_for "Users::User" do
          fields [
            :language,
            :language_english_name,
            :language_code,
            :language_alpha3_code
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "language" do
      it { expect(subject).to have_key :language }
    end

    context "language_english_name" do
      it { expect(subject).to have_key :language_english_name }
    end

    context "language_code" do
      it { expect(subject).to have_key :language_code }
    end

    context "language_alpha3_code" do
      it { expect(subject).to have_key :language_alpha3_code }
    end
  end
end
