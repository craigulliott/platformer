# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ClassMap do
  let(:class_map_module) { Platformer::ClassMap }

  describe :validate_class_extends! do
    before(:each) do
      create_class "BaseModel", PlatformModel
      create_class "ChildModel", BaseModel
      create_class "UnrelatedModel", PlatformModel
    end

    it "raises an error if the class does not extend the provided base class" do
      expect {
        class_map_module.validate_class_extends! UnrelatedModel, BaseModel
      }.to raise_error(Platformer::ClassMap::ClassDoesNotExtendError)
    end

    it "raises an error if the classes are siblings of each other, but provided in the unexpected order" do
      expect {
        class_map_module.validate_class_extends! BaseModel, ChildModel
      }.to raise_error(Platformer::ClassMap::ClassDoesNotExtendError)
    end

    it "returns true if the class does extend the provided base class" do
      expect(class_map_module.validate_class_extends!(ChildModel, BaseModel)).to be true
    end
  end

  describe :namespace_from_class do
    describe "when the provided class is not namespaced" do
      before(:each) do
        create_class "TestClass"
      end

      it "returns rubys top object" do
        expect(class_map_module.namespace_from_class(TestClass)).to be Object
      end
    end

    describe "when the provided class is namespaced within a module" do
      before(:each) do
        create_class "MyModule::TestClass"
      end

      it "returns the expected module" do
        expect(class_map_module.namespace_from_class(MyModule::TestClass)).to be MyModule
      end
    end

    describe "when the provided class is namespaced within a multiple modules" do
      before(:each) do
        create_class "MyModule::MyOtherModule::TestClass"
      end

      it "returns the expected module" do
        expect(class_map_module.namespace_from_class(MyModule::MyOtherModule::TestClass)).to be MyModule::MyOtherModule
      end
    end
  end

  describe :application_record_class do
    it "returns the ApplicationRecord class" do
      # note, it is not possible to specifically test the creation of the ApplicationRecord class, as it
      # was probably created autmatically by a previous test. So, we just test that the class is returned
      expect(class_map_module.application_record_class).to be ApplicationRecord
    end
  end

  describe :base_application_record_class do
    before(:each) do
      create_class "BaseModel", PlatformModel
      create_class "ChildModel", BaseModel
      create_class "UnrelatedModel", PlatformModel
    end

    it "returns ApplicationRecord for a model class which extends PlatformModel" do
      expect(class_map_module.base_application_record_class(BaseModel)).to be ApplicationRecord
    end

    describe "after BaseModel has been built" do
      before(:each) do
        class_map_module.create_active_record_class_from_model_class(BaseModel)
      end

      it "returns Base for a class which extends BaseModel" do
        expect(class_map_module.base_application_record_class(ChildModel)).to be Base
      end
    end
  end

  describe :create_active_record_class_from_model_class do
    describe "for a User model definition which is namespaced within Users" do
      before(:each) do
        create_class "Users::UserModel", PlatformModel do
          integer_field :age
        end
      end

      after(:each) do
        destroy_class Users::User
      end

      it "returns the expected active record class" do
        expect(class_map_module.create_active_record_class_from_model_class(Users::UserModel)).to be Users::User
      end

      describe "where the Users::User model has been successfully created" do
        before(:each) do
          # this will create the Users::User class, and make it available to the tests below
          class_map_module.create_active_record_class_from_model_class(Users::UserModel)
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(Users::User < ApplicationRecord).to be true
        end

        it "raises an error if the active record class already exists" do
          expect {
            class_map_module.create_active_record_class_from_model_class(Users::UserModel)
          }.to raise_error Platformer::ClassMap::ActiveRecordClassAlreadyCreatedError
        end
      end
    end

    describe "for a Foo model definition which is not namespaced" do
      before(:each) do
        create_class "FooModel", PlatformModel do
          integer_field :age
        end
      end

      after(:each) do
        destroy_class Foo
      end

      it "returns the expected active record class" do
        expect(class_map_module.create_active_record_class_from_model_class(FooModel)).to be Foo
      end

      describe "where the Foo model has been successfully created" do
        before(:each) do
          # this will create the Foo class, and make it available to the tests below
          class_map_module.create_active_record_class_from_model_class(FooModel)
        end

        it "returns an active record class with the expected table_name_prefix" do
          expect(Foo.table_name_prefix).to eq("")
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(Foo < ApplicationRecord).to be true
        end

        it "raises an error if the active record class already exists" do
          expect {
            class_map_module.create_active_record_class_from_model_class(FooModel)
          }.to raise_error Platformer::ClassMap::ActiveRecordClassAlreadyCreatedError
        end
      end
    end
  end

  describe :get_active_record_class_from_model_class do
    describe "for a User model definition which is namespaced within Users" do
      before(:each) do
        create_class "Users::UserModel", PlatformModel do
          integer_field :age
        end
      end

      it "raises an error if the class does not exist yet" do
        expect {
          class_map_module.get_active_record_class_from_model_class(Users::UserModel)
        }.to raise_error Platformer::ClassMap::ActiveRecordClassDoesNotExistError
      end

      describe "where the Users::User model has been successfully created" do
        before(:each) do
          # this will create the Users::User class, and make it available to the tests below
          class_map_module.create_active_record_class_from_model_class(Users::UserModel)
        end

        after(:each) do
          destroy_class Users::User
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(class_map_module.get_active_record_class_from_model_class(Users::UserModel) < ApplicationRecord).to be true
        end
      end
    end

    describe "for a Foo model definition which is not namespaced" do
      before(:each) do
        create_class "FooModel", PlatformModel do
          integer_field :age
        end
      end

      it "raises an error if the class does not exist yet" do
        expect {
          class_map_module.get_active_record_class_from_model_class(FooModel)
        }.to raise_error Platformer::ClassMap::ActiveRecordClassDoesNotExistError
      end

      describe "where the Foo model has been successfully created" do
        before(:each) do
          # this will create the Foo class, and make it available to the tests below
          class_map_module.create_active_record_class_from_model_class(FooModel)
        end

        after(:each) do
          destroy_class Foo
        end

        it "returns an active record class with the expected table_name_prefix" do
          expect(class_map_module.get_active_record_class_from_model_class(FooModel).table_name_prefix).to eq("")
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(class_map_module.get_active_record_class_from_model_class(FooModel) < ApplicationRecord).to be true
        end
      end
    end
  end
end
