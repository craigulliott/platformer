# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Server::Routes::HealthCheck do
  include Rack::Test::Methods

  def app
    Platformer::Server::Routes::HealthCheck
  end

  context "GET /health_check" do
    it "returns the expected success payload" do
      get "/health_check"

      expect(last_response.status).to eq(200)

      expect(JSON.parse(last_response.body)).to eql({
        "success" => true,
        "message" => "OK"
      })
    end
  end
end
