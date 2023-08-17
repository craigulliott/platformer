# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Databases::Migrations::Current::Loader do
  # fixtures for this spec exist in this folder
  let(:base_path) { File.expand_path("./spec/data/db/migrations") }

  let(:loader) { Platformer::Databases::Migrations::Current::Loader.new base_path }

  describe :initialize do
    it "initialises without error" do
      expect {
        Platformer::Databases::Migrations::Current::Loader.new base_path
      }.to_not raise_error
    end
  end

  describe :migrations do
    it "returns an array representation of the current migrations on disk" do
      expect(loader.migrations).to be_a Array
      expect(loader.migrations.count).to eq 1
      expect(loader.migrations.first.timestamp).to eq 20231016233801
      expect(loader.migrations.first.name).to eq :create_user
    end
  end
end
