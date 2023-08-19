# frozen_string_literal: true

require "spec_helper"
require "fileutils"

RSpec.describe Platformer::Databases::Migrations::Current do
  # create a dedicated tmp folder for this spec
  let(:base_path) { File.expand_path("./tmp/spec/unit/platformer/databases/migrations/current") }

  before(:each) do
    # if the dedicated tmp folder exists, make sure its empty
    if File.directory?(base_path)
      FileUtils.rm_rf("tmp/spec/unit/platformer/databases/migrations/current")

    # if it doesn't exist, then create it
    else
      FileUtils.mkdir_p(base_path)
    end
  end

  let(:current) { Platformer::Databases::Migrations::Current.new base_path }

  describe :initialize do
    it "initializes without error" do
      expect {
        Platformer::Databases::Migrations::Current.new base_path
      }.to_not raise_error
    end
  end

  describe :create_migration do
    it "adds a new migration to the list and saves it to disk" do
      current.create_migration type: :postgres,
        server_name: :test_server,
        database_name: :test_database,
        schema_name: :test_schema,
        name: :my_migration,
        contents: <<~CONTENTS
          # my migration
        CONTENTS

      expect(current.migrations).to be_a Array
      expect(current.migrations.count).to eq 1
      expect(current.migrations.first.name).to eq :my_migration
    end

    describe "after a migration has been created" do
      before(:each) do
        current.create_migration type: :postgres,
          server_name: :test_server,
          database_name: :test_database,
          schema_name: :test_schema,
          name: :my_migration,
          contents: <<~CONTENTS
            # my migration
          CONTENTS
      end

      it "adds a number to automatically increment the migration name if it collides with the migration which already exists" do
        current.create_migration type: :postgres,
          server_name: :test_server,
          database_name: :test_database,
          schema_name: :test_schema,
          name: :my_migration,
          contents: <<~CONTENTS
            # my migration
          CONTENTS

        expect(current.migrations).to be_a Array
        expect(current.migrations.count).to eq 2
        expect(current.migrations.first).to be_a Platformer::Databases::Migrations::MigrationFile
        expect(current.migrations.first.name).to eq :my_migration
        expect(current.migrations.last.name).to eq :my_migration1
      end
    end
  end

  describe :migrations do
    it "returns an empty array because there are no migrations in the current folder" do
      expect(current.migrations).to eql []
    end

    describe "after a migration has been created" do
      before(:each) do
        current.create_migration type: :postgres,
          server_name: :test_server,
          database_name: :test_database,
          schema_name: :test_schema,
          name: :my_migration,
          contents: <<~CONTENTS
            # my migration
          CONTENTS
      end

      it "returns the expected array of migrations" do
        expect(current.migrations).to be_a Array
        expect(current.migrations.count).to eq 1
        expect(current.migrations.first).to be_a Platformer::Databases::Migrations::MigrationFile
        expect(current.migrations.first.name).to eq :my_migration
      end
    end
  end
end
