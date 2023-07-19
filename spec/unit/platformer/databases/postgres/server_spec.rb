# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Databases::Postgres::Server do
  let(:server) { Platformer::Databases::Postgres::Server.new :primary }
  let(:database_configuration) { YAML.load_file("config/database.yaml") }

  describe :initialize do
    it "initializes a new object without error" do
      expect {
        Platformer::Databases::Postgres::Server.new :primary
      }.to_not raise_error
    end

    it "raises an error if the configuration does not exist in database.yaml" do
      expect {
        Platformer::Databases::Postgres::Server.new :not_a_real_server
      }.to raise_error Platformer::Databases::Configuration::MissingConfigurationError
    end
  end

  describe :structure do
    it "returns a structure object" do
      expect(server.structure).to be_a(DynamicMigrations::Postgres::Server)
    end
  end

  describe :name do
    it "returns the expected name" do
      expect(server.name).to eq :primary
    end
  end

  describe :host do
    it "returns the expected host" do
      expect(server.host).to eq database_configuration["postgres"]["primary"]["host"]
    end
  end

  describe :port do
    it "returns the expected port" do
      expect(server.port).to eq database_configuration["postgres"]["primary"]["port"]
    end
  end

  describe :username do
    it "returns the expected username" do
      expect(server.username).to eq database_configuration["postgres"]["primary"]["username"]
    end
  end

  describe :password do
    it "returns the expected password" do
      expect(server.password).to eq database_configuration["postgres"]["primary"]["password"]
    end
  end

  describe :database do
    it "returns the expected Database" do
      expect(server.database(:foo_database)).to be_a(Platformer::Databases::Postgres::Server::Database)
      expect(server.database(:foo_database).name).to eq(:foo_database)
    end
  end

  describe :default_database do
    it "returns the expected Database" do
      expect(server.default_database).to be_a(Platformer::Databases::Postgres::Server::Database)
      expect(server.default_database.name).to eql(database_configuration["postgres"]["primary"]["default_database"].to_sym)
    end
  end
end
