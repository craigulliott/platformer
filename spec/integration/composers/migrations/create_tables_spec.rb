# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::CreateTables do
  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        integer_field :age
      end
    end

    after(:each) do
      destroy_class Users::User
    end

    it "creates the expected ActiveRecord class" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::Migrations::CreateTables.rerun
    end
  end
end
