# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Documentation do
  # create a dedicated tmp folder for this spec
  let(:base_path) { Platformer.root "tmp/spec/unit/platformer/documentation_spec" }

  let(:documentation) { Platformer::Documentation.new :models, Platformer::BaseModel, base_path, 0 }

  before(:each) do
    # if the dedicated tmp folder exists, make sure its empty
    if File.directory?(base_path)
      FileUtils.rm_rf(base_path)

    # if it doesn't exist, then create it
    else
      FileUtils.mkdir_p(base_path)
    end
  end

  before(:each) do
    # clear the generated docs folder
    FileUtils.rm_rf(base_path)
    # recreate the folder
    FileUtils.mkdir_p(base_path)
  end

  describe :initialize do
    it "initializes without error" do
      expect {
        Platformer::Documentation.new :models, Platformer::BaseModel, base_path, 0
      }.to_not raise_error
    end
  end

  describe :generate do
    it "generates a documentation file" do
      documentation.generate
      expect(File.file?(base_path + "/models/index.md")).to be true
    end
  end
end
