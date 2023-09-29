# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Language do
  describe "for a new UserModel which defines a simple new model with a language field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :language, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          language_field
        end
      end
    end

    subject {
      user = Users::User.new(language: "LANG_EN")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.language_english_name).to eq "English" }

      it { expect(subject.language_code).to eq "en" }

      it { expect(subject.language_alpha3_code).to eq "eng" }
    end
  end
end
