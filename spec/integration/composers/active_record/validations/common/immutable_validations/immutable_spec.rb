# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Common::Immutable do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, Platformer::BaseModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new UserModel which defines a simple new model with an integer field and immutable validation" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :integer
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        integer_field :foo do
          immutable
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Validations::Common::Immutable.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "has the expected immutable_validator" do
      immutable_validator = Users::User.validators.find { |v| v.instance_of? ImmutableValidator }

      expect(immutable_validator).to_not be_nil
      expect(immutable_validator.attributes).to eql([:foo])
    end

    it "has a immutable_validator which fails when expected" do
      user = Users::User.create! foo: 123
      user.foo = 456
      expect(user.valid?).to be false
    end
  end
end
