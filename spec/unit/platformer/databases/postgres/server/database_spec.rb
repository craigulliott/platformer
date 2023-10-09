# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Databases::Postgres::Server::Database do
  let(:server) { Platformer::Databases::Postgres::Server.new :primary }
  let(:database) { server.database :foo_database }
  let(:database_configuration) { YAML.load_file("config/database.yaml") }

  describe :initialize do
    it "initializes a new object without error" do
      expect {
        Platformer::Databases::Postgres::Server::Database.new server, :foo_database
      }.to_not raise_error
    end
  end

  describe :name do
    it "returns the expected name" do
      expect(database.name).to eq :foo_database
    end
  end

  describe :server do
    it "returns the expected server" do
      expect(database.server).to eq server
    end
  end

  describe :structure do
    it "returns the expected structure" do
      expect(database.structure).to be_a(DynamicMigrations::Postgres::Server::Database)
    end
  end

  describe :active_record_configuration do
    it "returns the expected active_record_configuration" do
      expect(database.active_record_configuration).to eql({
        host: database_configuration["postgres"]["primary"]["host"],
        port: database_configuration["postgres"]["primary"]["port"],
        username: database_configuration["postgres"]["primary"]["username"],
        password: database_configuration["postgres"]["primary"]["password"],
        database: "foo_database",
        encoding: "utf8",
        adapter: "postgis",
        schema_search_path: "public,postgis"
      })
    end
  end

  describe :pg_configuration do
    it "returns the expected pg_configuration" do
      expect(database.pg_configuration).to eql({
        host: database_configuration["postgres"]["primary"]["host"],
        port: database_configuration["postgres"]["primary"]["port"],
        user: database_configuration["postgres"]["primary"]["username"],
        password: database_configuration["postgres"]["primary"]["password"],
        dbname: :foo_database,
        sslmode: "prefer"
      })
    end
  end
end
