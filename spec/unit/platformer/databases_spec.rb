# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Databases do
  describe :postgres_server do
    it "creates and returns a new server" do
      expect(Platformer::Databases.postgres_server(:primary)).to be_a(Platformer::Databases::Postgres::Server)
    end

    it "raises an error if the configuration does not exist in database.yaml" do
      expect {
        Platformer::Databases.postgres_server :not_a_real_server
      }.to raise_error Platformer::Databases::Configuration::MissingConfigurationError
    end

    describe "if a server has already been added" do
      let(:server) { Platformer::Databases.postgres_server :primary }

      before(:each) do
        server
      end

      it "returns the server with the same name, rather than creating a new one" do
        expect(Platformer::Databases.postgres_server(:primary)).to be(server)
      end
    end
  end

  describe :clear_configuration do
    it "does not raise an error" do
      expect {
        Platformer::Databases.clear_configuration
      }.to_not raise_error
    end

    describe "if a server has already been added" do
      let(:server) { Platformer::Databases.postgres_server :primary }

      before(:each) do
        server
      end

      it "does not raise an error" do
        expect {
          Platformer::Databases.clear_configuration
        }.to_not raise_error
      end

      it "clears the configuration" do
        expect(Platformer::Databases.postgres_servers).to eql [server]
        Platformer::Databases.clear_configuration
        expect(Platformer::Databases.postgres_servers).to eql []
      end
    end
  end

  describe :postgres_servers do
    it "returns an empty array" do
      expect(Platformer::Databases.postgres_servers).to eql []
    end

    describe "if a server has already been added" do
      let(:server) { Platformer::Databases.postgres_server :primary }

      before(:each) do
        server
      end

      it "returns an array of the added servers" do
        expect(Platformer::Databases.postgres_servers).to eql [server]
      end
    end
  end
end
