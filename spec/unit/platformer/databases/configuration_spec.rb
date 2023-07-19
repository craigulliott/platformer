# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Databases::Configuration do
  let(:database_configuration) { YAML.load_file("config/database.yaml") }

  describe :value do
    it "returns the expected value from config/database.yaml" do
      expect(Platformer::Databases::Configuration.value(:postgres, :primary, :host)).to eql(database_configuration["postgres"]["primary"]["host"])
    end

    it "returns nil if the requested item is not in config/database.yaml" do
      expect(Platformer::Databases::Configuration.value(:postgres, :primary, :not_an_actual_key)).to eql(nil)
    end
  end

  describe :require_value do
    it "returns the expected value from config/database.yaml" do
      expect(Platformer::Databases::Configuration.require_value(:postgres, :primary, :host)).to eql(database_configuration["postgres"]["primary"]["host"])
    end

    it "raises an error if the requested item is not in config/database.yaml" do
      expect {
        Platformer::Databases::Configuration.require_value(:postgres, :primary, :not_an_actual_key)
      }.to raise_error Platformer::Databases::Configuration::MissingConfigurationError
    end
  end

  describe :file_contents do
    it "returns the configuration from config/database.yaml" do
      expect(Platformer::Databases::Configuration.file_contents).to eql(database_configuration)
    end
  end
end
