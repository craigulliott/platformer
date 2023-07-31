# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::NumericValidations do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, PlatformModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new UserModel which defines a simple new model with an integer field and validations" do
    before(:each) do
      pg_helper.create_table :public, :users
      pg_helper.create_column :public, :users, :age, :integer

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        integer_field :age do
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Validations::NumericValidations.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "creates the expected numericality_validator" do
      numericality_validator = Users::User.validators.find { |v| v.instance_of? ActiveRecord::Validations::NumericalityValidator }

      expect(numericality_validator).to_not be_nil
      expect(numericality_validator.options).to eql({only_integer: true})
      expect(numericality_validator.attributes).to eql([:age])
    end

    it "creates a numericality_validator which fails when expected" do
      user = Users::User.new age: :foo

      expect(user.valid?).to be false
    end

    it "creates a numericality_validator which succeeds when expected" do
      user = Users::User.new age: 1

      expect(user.valid?).to be true
    end
  end
end
