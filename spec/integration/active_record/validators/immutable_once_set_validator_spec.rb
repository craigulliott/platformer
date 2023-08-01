# frozen_string_literal: true

require "spec_helper"

RSpec.describe ImmutableOnceSetValidator do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }
  let(:default_database_configuration) { RSpec.configuration.default_database_configuration }

  describe "for a new active record model" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :varchar
      end

      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # add the validator
        validates :foo, immutable_once_set: true
      end
    end

    it "creates the expected record with an empty foo value" do
      user = User.create foo: nil
      expect(user.id).to_not be_nil
      expect(user.foo).to be_nil
    end

    it "creates the expected record with a non empty foo value" do
      user = User.create foo: "abc"
      expect(user.id).to_not be_nil
      expect(user.foo).to eq "abc"
    end

    describe "for a record which already exists with an empty foo value" do
      let(:user) { User.create foo: nil }

      before(:each) do
        user
      end

      it "allows the value of foo to be updated" do
        expect(user.errors.map(&:type)).to eql []
        expect(user.update(foo: "abc")).to be true
        expect(user.errors.map(&:type)).to eql []
      end
    end

    describe "for a record which already exists with a non empty foo value" do
      let(:user) { User.create foo: "abc" }

      before(:each) do
        user
      end

      it "does not allow the value of foo to be updated" do
        expect(user.errors.map(&:type)).to eql []
        expect(user.update(foo: "def")).to be false
        expect(user.errors.map(&:type)).to eql ["can not be changed once set"]
      end
    end
  end
end
