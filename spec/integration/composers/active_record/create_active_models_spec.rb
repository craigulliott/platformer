# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::CreateActiveModels do
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
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun

      expect(Users::User < ApplicationRecord).to be true
      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end
  end

  describe "for a new FooModel which extends a BarModel" do
    before(:each) do
      create_class "BarModel", PlatformModel do
      end
      create_class "FooModel", BarModel do
      end
    end

    after(:each) do
      destroy_class Foo
      destroy_class Bar
    end

    it "creates the expected ActiveRecord class hierachy" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun

      expect(Foo < Bar).to be true
      expect(Bar < ApplicationRecord).to be true
      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end
  end

  describe "for a new UserModel which connects to a postgres server and a default database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        use_postgres_database :primary
      end
    end

    after(:each) do
      destroy_class Users::User
    end

    it "creates the expected ActiveRecord connection" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun

      expect {
        Users::User.connection
      }.to_not raise_error

      expect(Users::User.connected?).to be true
    end
  end

  describe "for a new UserModel which connects to a postgres server and a specific database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        use_postgres_database :primary, database: :specific_database
      end
    end

    after(:each) do
      destroy_class Users::User
    end

    it "creates the expected ActiveRecord connection configuration" do
      # now that the UserModel has been created, we rerun the composer

      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun

      # note we dont actually test the configuration here, because this
      # database doesn't exist
      expect(Users::User.connection_db_config.database).to eq "specific_database"
    end
  end

  describe "for a new UserModel which uses a specifc postgres database schema" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        schema :users
      end
    end

    after(:each) do
      destroy_class Users::User
    end

    it "returns an active record class with the expected table_name_prefix" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun

      expect(Users::User.table_name_prefix).to eq("users.")
    end
  end
end
