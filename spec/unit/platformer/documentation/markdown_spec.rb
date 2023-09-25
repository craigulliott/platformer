# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Documentation::Markdown do
  # create a dedicated tmp folder for this spec
  let(:base_path) { Platformer.root "tmp/spec/unit/platformer/documentation/markdown_spec" }

  let(:markdown) { Platformer::Documentation::Markdown.new base_path, "index.md" }

  before(:each) do
    # if the dedicated tmp folder exists, make sure its empty
    if File.directory?(base_path)
      FileUtils.rm_rf(base_path)

    # if it doesn't exist, then create it
    else
      FileUtils.mkdir_p(base_path)
    end
  end

  describe :initialize do
    it "initializes without error" do
      expect {
        Platformer::Documentation::Markdown.new base_path, "docs.md"
      }.to_not raise_error
    end
  end

  describe :text do
    it "cleans up and returns a new section of markdown" do
      test_string = <<~TEST_STRING


        Foo
        Bar

        Should work fine with special chars $
        * and so on

        It should not remove too much indentation from lines which have additional indentation
          Such as this

      TEST_STRING

      expect(markdown.text(test_string)).to eq <<~EXPECTED_STRING.strip
        Foo
        Bar

        Should work fine with special chars $
        * and so on

        It should not remove too much indentation from lines which have additional indentation
          Such as this
      EXPECTED_STRING
    end

    it "returns nil for an empty string" do
      expect(markdown.text("")).to be_nil
    end
  end

  describe :h1 do
    it "adds and returns markdown h1" do
      expect(markdown.h1("Foo")).to eq("# Foo\n{: .no_toc }")
    end

    it "returns nil for an empty string" do
      expect(markdown.h1("")).to be_nil
    end
  end

  describe :h2 do
    it "adds and returns markdown h2" do
      expect(markdown.h2("Foo")).to eq("## Foo")
    end

    it "returns nil for an empty string" do
      expect(markdown.h2("")).to be_nil
    end
  end

  describe :h3 do
    it "adds and returns markdown h3" do
      expect(markdown.h3("Foo")).to eq("### Foo")
    end

    it "returns nil for an empty string" do
      expect(markdown.h3("")).to be_nil
    end
  end

  describe :h4 do
    it "adds and returns markdown h4" do
      expect(markdown.h4("Foo")).to eq("#### Foo")
    end

    it "returns nil for an empty string" do
      expect(markdown.h4("")).to be_nil
    end
  end

  describe :h5 do
    it "adds and returns markdown h5" do
      expect(markdown.h5("Foo")).to eq("##### Foo")
    end

    it "returns nil for an empty string" do
      expect(markdown.h5("")).to be_nil
    end
  end

  describe :h6 do
    it "adds and returns markdown h6" do
      expect(markdown.h6("Foo")).to eq("###### Foo")
    end

    it "returns nil for an empty string" do
      expect(markdown.h6("")).to be_nil
    end
  end

  describe :code do
    it "adds and returns a code block" do
      expect(markdown.code("a = 1")).to eq("```ruby\na = 1\n```")
    end

    it "returns nil for an empty string" do
      expect(markdown.code("")).to be_nil
    end
  end

  describe :to_markdown do
    it "returns an empty string" do
      expect(markdown.to_markdown).to eq("")
    end

    describe "After a section has been added" do
      before(:each) do
        markdown.text("Foo bar")
      end

      it "returns the expected markdown" do
        expect(markdown.to_markdown).to eq("Foo bar")
      end

      describe "After another section has been added" do
        before(:each) do
          markdown.text("Foz baz")
        end

        it "combines the two sections and returns the expected markdown" do
          expect(markdown.to_markdown).to eq("Foo bar\n\nFoz baz")
        end

        describe "After a h1 has been added" do
          before(:each) do
            markdown.h1("Header")
          end

          it "combines the two sections and returns the expected markdown" do
            expect(markdown.to_markdown).to eq <<~MARKDOWN.strip
              Foo bar

              Foz baz

              # Header
              {: .no_toc }
            MARKDOWN
          end
        end
      end
    end
  end
end
