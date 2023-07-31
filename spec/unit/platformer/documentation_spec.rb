# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Documentation do
  let(:documentation) { Platformer::Documentation.new }

  describe :initialize do
    it "initializes without error" do
      expect {
        Platformer::Documentation.new
      }.to_not raise_error
    end
  end

  describe :add_composer_class do
    it "documents a composer class without error" do
      expect {
        documentation.add_composer_class(PlatformModel)
      }.to_not raise_error
    end
  end

  describe :to_markdown do
    it "returns an empty string" do
      expect(documentation.to_markdown).to eq ""
    end

    describe "after a composer class has been added" do
      before(:each) do
        documentation.add_composer_class(PlatformModel)
      end

      it "returns a longer string" do
        expect(documentation.to_markdown.length > 100).to be true
      end
    end
  end
end
