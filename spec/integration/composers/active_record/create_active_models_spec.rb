# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::CreateActiveModels do
  describe "for a schema base class" do
    before(:each) do
      scaffold do
        # note that both of these name space parts are Users (plural)
        model_for "Users::Users" do
          database :postgres, :primary
          schema :users
        end
      end
    end

    it "creates an abstract class" do
      expect(Users::UsersRecord.abstract_class).to be true
    end

    it "creates the expected ActiveRecord class hierachy" do
      expect(Users::UsersRecord < ApplicationRecord).to be true

      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end

    it "creates the expected ActiveRecord connection" do
      expect {
        Users::UsersRecord.connection
      }.to_not raise_error

      expect(Users::UsersRecord.connected?).to be true
    end

    it "returns an active record class with the expected table_name_prefix" do
      expect(Users::UsersRecord.table_name_prefix).to eq("users.")
    end
  end

  describe "for a simple Users::AvatarModel" do
    before(:each) do
      scaffold do
        model_for "Users::Avatar" do
          database :postgres, :primary
          schema :users
        end
      end
    end

    it "creates the expected ActiveRecord class hierachy" do
      expect(Users::Avatar < Users::UsersRecord).to be true

      expect(Users::UsersRecord < ApplicationRecord).to be true

      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end

    it "creates an abstract schema base class" do
      expect(Users::UsersRecord.abstract_class).to be true
    end

    it "creates a non abstract class for the Avatar" do
      expect(Users::Avatar.abstract_class).to_not be true
    end

    it "creates the expected ActiveRecord connection" do
      expect {
        Users::Avatar.connection
      }.to_not raise_error

      expect(Users::Avatar.connected?).to be true
    end

    it "returns an active record class with the expected table_name_prefix" do
      expect(Users::Avatar.table_name_prefix).to eq("users.")
    end
  end

  describe "for a simple Users::AvatarModel which connects to a specific postgres database" do
    before(:each) do
      scaffold do
        model_for "Users::Avatar" do
          database :postgres, :primary, database_name: :specific_database
          schema :users
        end
      end
    end

    it "creates the expected ActiveRecord class hierachy" do
      expect(Users::Avatar < Users::UsersRecord).to be true

      expect(Users::UsersRecord < ApplicationRecord).to be true

      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end

    it "creates the expected ActiveRecord connection configuration" do
      # note we dont actually test the configuration here, because this
      # database doesn't exist
      expect(Users::Avatar.connection_db_config.database).to eq "specific_database"
    end
  end

  describe "for an STI model" do
    before(:each) do
      scaffold do
        model_for "Communication::TextMessage" do
          database :postgres, :primary
          schema :users
        end

        model_for "Communication::TextMessages::Welcome", Communication::TextMessageModel do
        end
      end
    end

    it "creates the expected ActiveRecord class hierachy" do
      expect(Communication::TextMessages::Welcome < Communication::TextMessage).to be true

      expect(Communication::TextMessage < Communication::CommunicationRecord).to be true

      expect(Communication::CommunicationRecord < ApplicationRecord).to be true

      expect(ApplicationRecord < ActiveRecord::Base).to be true
    end
  end
end
