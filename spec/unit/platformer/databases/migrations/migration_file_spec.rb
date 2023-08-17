# frozen_string_literal: true

require "spec_helper"
require "fileutils"

RSpec.describe Platformer::Databases::Migrations::MigrationFile do
  # create a dedicated tmp folder for this spec
  let(:base_path) { File.expand_path("./tmp/spec/unit/platformer/databases/migrations/migration_file") }

  before(:each) do
    # if the dedicated tmp folder exists, make sure its empty
    if File.directory?(base_path)
      FileUtils.rm_rf("tmp/spec/unit/platformer/databases/migrations/migration_file")

    # if it doesn't exist, then create it
    else
      FileUtils.mkdir_p(base_path)
    end
  end

  let(:migration_file) {
    Platformer::Databases::Migrations::MigrationFile.new base_path: base_path,
      type: :postgres,
      server_name: :my_server,
      database_name: :my_database,
      schema_name: :my_schema,
      timestamp: 20230816184604,
      name: :my_migration
  }

  describe :initialize do
    it "initializes without error" do
      expect {
        migration_file
      }.to_not raise_error
    end
  end

  describe :base_path do
    it "returns the expected base_path" do
      expect(migration_file.base_path).to be_a Pathname
      expect(migration_file.base_path.to_s.end_with?("platformer/databases/migrations/migration_file")).to be true
    end
  end

  describe :type do
    it "returns the expected type" do
      expect(migration_file.type).to eq :postgres
    end
  end

  describe :server_name do
    it "returns the expected server_name" do
      expect(migration_file.server_name).to eq :my_server
    end
  end

  describe :database_name do
    it "returns the expected database_name" do
      expect(migration_file.database_name).to eq :my_database
    end
  end

  describe :schema_name do
    it "returns the expected schema_name" do
      expect(migration_file.schema_name).to eq :my_schema
    end
  end

  describe :timestamp do
    it "returns the expected timestamp" do
      expect(migration_file.timestamp).to eq 20230816184604
    end
  end

  describe :name do
    it "returns the expected name" do
      expect(migration_file.name).to eq :my_migration
    end
  end

  # this method also tests the `contents` method
  describe :create_file do
    # we use the Loader class to check the results within the specs below
    let(:loader) { Platformer::Databases::Migrations::Current::Loader.new base_path }

    it "creates the file on disk with the provided contents inside the expected module, class and method definition" do
      migration_file.create_file "# my migration content"

      expect(loader.migrations).to be_a Array
      expect(loader.migrations.count).to eq 1
      expect(loader.migrations.first).to be_a Platformer::Databases::Migrations::MigrationFile
      expect(loader.migrations.first.name).to eq :my_migration
      expect(loader.migrations.first.contents).to eq <<~RUBY
        module Migrations
          module Postgres
            module MyServer
              module MyDatabase
                module MySchema
                  class MyMigration < ActiveRecord::Migration[7.0]
                    # include the enhahnced migration methods
                    include DynamicMigrations::ActiveRecord::Migrators

                    def change
                      # my migration content
                    end
                  end
                end
              end
            end
          end
        end
      RUBY
    end
  end

  describe :contents do
    # see the create_file method spec above
  end
end
