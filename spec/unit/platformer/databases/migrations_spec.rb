# frozen_string_literal: true

require "spec_helper"
require "fileutils"

RSpec.describe Platformer::Databases::Migrations do
  # create a dedicated tmp folder for this spec
  let(:base_path) { Platformer.root "tmp/spec/unit/platformer/databases/migrations_spec" }
  # we use the Loader class to check the results within the specs below
  let(:loader) { Platformer::Databases::Migrations::Current::Loader.new base_path }

  before(:each) do
    # if the dedicated tmp folder exists, make sure its empty
    if File.directory?(base_path)
      FileUtils.rm_rf(base_path)

    # if it doesn't exist, then create it
    else
      FileUtils.mkdir_p(base_path)
    end
  end

  let(:migrations) { Platformer::Databases::Migrations.new base_path }

  describe :initialize do
    it "initializes without error" do
      expect {
        Platformer::Databases::Migrations.new base_path
      }.to_not raise_error
    end
  end

  describe :generate_migration_files do
    describe "for a configured database with only a public schema" do
      let(:database) { Platformer::Databases.server(:postgres, :primary).default_database }
      let(:schema) { database.structure.add_configured_schema :public }

      before(:each) do
        schema
      end

      it "does nothing because there are no differences between the configured and loaded schema" do
        migrations.generate_migration_files
        expect(loader.migrations).to eql []
      end

      describe "after a new schema and table has been added to the configured structure of a database" do
        before(:each) do
          schema.add_table :my_table, description: "my table description"
        end

        it "generates a migration file for the new schema and table" do
          migrations.generate_migration_files
          expect(loader.migrations).to be_a Array
          expect(loader.migrations.count).to eq 1
          expect(loader.migrations.first).to be_a Platformer::Databases::Migrations::MigrationFile
          expect(loader.migrations.first.name).to eq :create_my_table
          expect(loader.migrations.first.contents).to eq <<~RUBY
            module Migrations
              module Postgres
                module Primary
                  module PlatformerTest
                    module Public
                      class CreateMyTable < ActiveRecord::Migration[7.0]
                        # include the enhahnced migration methods
                        include DynamicMigrations::ActiveRecord::Migrators

                        def change
                          #
                          # Create Table
                          #
                          table_comment = <<~COMMENT
                            my table description
                          COMMENT
                          create_table :my_table, id: false, comment: table_comment do |t|
                          end
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
    end
  end
end
