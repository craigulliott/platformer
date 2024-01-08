# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ActiveRecord::Coercions::LowercaseCoercion do
  describe "for a new active record model which includes this coercion" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :varchar
      end

      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # include the coercion
        include Platformer::ActiveRecord::Coercions::LowercaseCoercion
        # add the attribute to be coerced
        attr_lowercase_coercion :foo
      end
    end

    describe :class_methods do
      describe :lowercase_coercion_attributes do
        it "returns the expected attributes" do
          expect(User.lowercase_coercion_attributes).to eql ["foo"]
        end
      end

      describe :lowercase_coercion_attribute? do
        it "returns true for attributes which have been added" do
          expect(User.lowercase_coercion_attribute?("foo")).to be true
        end

        it "returns false for attributes which have not been added" do
          expect(User.lowercase_coercion_attribute?("not_added")).to be false
        end
      end
    end

    it "automatically lowercases the attribute when it is saved" do
      user = User.create!(foo: "BAR")
      expect(user.foo).to eql "bar"
    end
  end
end
