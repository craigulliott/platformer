# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Fields::Boolean do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, Platformer::BaseModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new UserModel which defines a simple new model with a boolean field which is validated to always being true" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :boolean
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        boolean_field :foo do
          validate_is_true
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Validations::Fields::Boolean.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "has the expected default inclusion validator which all boolean fields have, and the specific `is true`` validator" do
      inclusion_validators = Users::User.validators.filter { |v| v.instance_of? ActiveModel::Validations::InclusionValidator }

      # the first validator is the default which is applied to all boolean fields
      expect(inclusion_validators.first.options).to eql({
        allow_nil: false,
        in: [true, false]
      })

      # the other validator is the special one which we added to restrict to only true
      expect(inclusion_validators.last.options).to eql({
        allow_nil: false,
        in: [true]
      })
    end

    it "has a inclusion_validator which fails when expected" do
      user = Users::User.new foo: false

      expect(user.valid?).to be false
    end

    it "has a inclusion_validator which succeeds when expected" do
      user = Users::User.new foo: true

      expect(user.valid?).to be true
    end
  end
end
