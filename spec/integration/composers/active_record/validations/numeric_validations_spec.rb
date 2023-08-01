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

  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :integer
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        integer_field :foo do
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Validations::NumericValidations.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "has the expected default numericality_validator because this is a numeric field" do
      numericality_validator = Users::User.validators.find { |v| v.instance_of? ActiveRecord::Validations::NumericalityValidator }

      expect(numericality_validator).to_not be_nil
      expect(numericality_validator.options).to eql({only_integer: true})
      expect(numericality_validator.attributes).to eql([:foo])
    end

    it "has a numericality_validator which fails when expected" do
      user = Users::User.new foo: "abc"

      expect(user.valid?).to be false
    end

    it "has a numericality_validator which succeeds when expected" do
      user = Users::User.new foo: 1

      expect(user.valid?).to be true
    end
  end
end
