# frozen_string_literal: true

require "spec_helper"

RSpec.describe ImmutableValidator do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }
  let(:default_database_configuration) { RSpec.configuration.default_database_configuration }

  describe "for a new active record model" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo_field, :varchar
      end

      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # add the validator
        validates :foo_field, not_nil: true
      end
    end

    it "forbids nil values" do
      user = User.new foo_field: nil
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql(["can not be null"])
    end

    it "permits non nil values" do
      user = User.new foo_field: "abc"
      expect(user.valid?).to be true
    end
  end
end
