# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::DSLReaders::Models::Database do
  describe "for a new UserModel which defines a simple new model and uses the database dsl" do
    before(:each) do
      # where no specific database name is provided
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        schema :users
      end

      # where a specific database name is provided
      create_class "Users::UserInSpecificDatabaseModel", PlatformModel do
        database :postgres, :primary, database_name: :specific_database
        schema :users
      end

      # where a schema was not provided
      create_class "Users::UserWithoutSchemaModel", PlatformModel do
        database :postgres, :primary
      end
    end

    let(:reader) { Platformer::DSLReaders::Models::Database.new Users::UserModel }
    let(:reader_with_database) { Platformer::DSLReaders::Models::Database.new Users::UserInSpecificDatabaseModel }
    let(:reader_without_schema) { Platformer::DSLReaders::Models::Database.new Users::UserWithoutSchemaModel }

    describe :server_type do
      it "returns the expected server_type" do
        expect(reader.server_type).to eq :postgres
      end
    end

    describe :server_name do
      it "returns the expected server_name" do
        expect(reader.server_name).to eq :primary
      end
    end

    describe :database_name do
      it "returns the expected database_name" do
        expect(reader.database_name).to eq nil
      end

      describe "when a database name was specified" do
        it "returns the expected database_name" do
          expect(reader_with_database.database_name).to eq :specific_database
        end
      end
    end

    describe :has_database_name? do
      it "returns false" do
        expect(reader.has_database_name?).to be false
      end

      describe "when a database name was specified" do
        it "returns true" do
          expect(reader_with_database.has_database_name?).to be true
        end
      end
    end

    describe :schema_name do
      it "returns the expected schema_name" do
        expect(reader.schema_name).to eq :users
      end

      describe "when the schema DSL was not used" do
        it "returns the default schema" do
          expect(reader_without_schema.schema_name).to eq :public
        end
      end
    end
  end
end
