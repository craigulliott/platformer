# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::CreatePresenters do
  describe "for a new UserModel which defines a simple new model" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
        end
      end
    end

    it "creates the expected Presenters class" do
      expect(Presenters::Users::User < Presenters::Base).to be true
    end
  end
end
