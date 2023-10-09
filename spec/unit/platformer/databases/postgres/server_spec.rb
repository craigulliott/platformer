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

  describe :pg_configuration do
    it "returns the expected pg_configuration" do
      expect(server.pg_configuration).to eql({
        host: database_configuration["postgres"]["primary"]["host"],
        port: database_configuration["postgres"]["primary"]["port"],
        user: database_configuration["postgres"]["primary"]["username"],
        password: database_configuration["postgres"]["primary"]["password"],
        sslmode: "prefer"
      })
    end
  end

  describe :databases do
    it "returns an empty array because no databases have been configured" do
      expect(server.databases).to eql []
    end

    describe "after two databases have been configured" do
      let(:foo_database) { server.database(:foo_database) }
      let(:bar_database) { server.database(:bar_database) }

      before do
        foo_database
        bar_database
      end

      it "returns an array of the expected Databases" do
        expect(server.databases).to eql [foo_database, bar_database]
      end
    end
  end

  describe :database_names do
    it "returns an empty array because no databases have been configured" do
      expect(server.database_names).to eql []
    end

    describe "after two databases have been configured" do
      let(:foo_database) { server.database(:foo_database) }
      let(:bar_database) { server.database(:bar_database) }

      before do
        foo_database
        bar_database
      end

      it "returns an array of the expected Database names" do
        expect(server.database_names).to eql [:foo_database, :bar_database]
      end
    end
  end

  describe :with_connection do
    it "yields with a connection argument" do
      connection = nil
      server.with_connection do |c|
        connection = c
      end
      expect(connection).to be_a(PG::Connection)
    end
  end
end
