# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ActiveRecord::Coercions::EmptyArrayToNullCoercion do
  describe "for a new active record model which includes this coercion" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :"integer[]"
      end

      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # include the coercion
        include Platformer::ActiveRecord::Coercions::EmptyArrayToNullCoercion
        # add the attribute to be coerced
        attr_empty_array_to_null_coercion :foo
      end
    end

    describe :class_methods do
      describe :empty_array_to_null_coercion_attributes do
        it "returns the expected attributes" do
          expect(User.empty_array_to_null_coercion_attributes).to eql ["foo"]
        end
      end

      describe :empty_array_to_null_coercion_attribute? do
        it "returns true for attributes which have been added" do
          expect(User.empty_array_to_null_coercion_attribute?("foo")).to be true
        end

        it "returns false for attributes which have not been added" do
          expect(User.empty_array_to_null_coercion_attribute?("not_added")).to be false
        end
      end
    end

    it "automatically converts empty array to null when the attribute is saved" do
      user = User.create!(foo: [])
      expect(user.foo).to be nil
    end
  end
end
