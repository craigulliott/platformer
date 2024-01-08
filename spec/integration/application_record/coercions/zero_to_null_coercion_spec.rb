# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ActiveRecord::Coercions::ZeroToNullCoercion do
  describe "for a new active record model which includes this coercion" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :integer
      end

      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # include the coercion
        include Platformer::ActiveRecord::Coercions::ZeroToNullCoercion
        # add the attribute to be coerced
        attr_zero_to_null_coercion :foo
      end
    end

    describe :class_methods do
      describe :zero_to_null_coercion_attributes do
        it "returns the expected attributes" do
          expect(User.zero_to_null_coercion_attributes).to eql ["foo"]
        end
      end

      describe :zero_to_null_coercion_attribute? do
        it "returns true for attributes which have been added" do
          expect(User.zero_to_null_coercion_attribute?("foo")).to be true
        end

        it "returns false for attributes which have not been added" do
          expect(User.zero_to_null_coercion_attribute?("not_added")).to be false
        end
      end
    end

    it "automatically converts zero values to null when the attribute is saved" do
      user = User.create!(foo: 0)
      expect(user.foo).to be nil
    end

    it "automatically converts zero float values to null when the attribute is saved" do
      user = User.create!(foo: 0.0)
      expect(user.foo).to be nil
    end
  end
end
