# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ClassMap do
  let(:class_map_module) { Platformer::ClassMap }

  describe :subclasses do
    before(:each) do
      create_class "Foo"
    end

    it "returns an empty array because this class has no subclasses" do
      expect(class_map_module.subclasses(Foo)).to eql []
    end

    describe "for a class with subclasses" do
      before(:each) do
        create_class "FooChildOne", Foo
        create_class "FooChildTwo", Foo
      end
      it "returns the expected list of subclasses" do
        expect(class_map_module.subclasses(Foo).sort_by(&:name)).to eql [FooChildOne, FooChildTwo]
      end
    end
  end

  describe :has_subclasses? do
    before(:each) do
      create_class "Foo"
    end

    it "returns false because this class has no subclasses" do
      expect(class_map_module.has_subclasses?(Foo)).to be false
    end

    describe "for a class with subclasses" do
      before(:each) do
        create_class "FooChildOne", Foo
        create_class "FooChildTwo", Foo
      end
      it "returns true" do
        expect(class_map_module.has_subclasses?(Foo)).to be true
      end
    end
  end

  describe :no_subclasses? do
    before(:each) do
      create_class "Foo"
    end

    it "returns true because this class has no subclasses" do
      expect(class_map_module.no_subclasses?(Foo)).to be true
    end

    describe "for a class with subclasses" do
      before(:each) do
        create_class "FooChildOne", Foo
        create_class "FooChildTwo", Foo
      end
      it "returns false" do
        expect(class_map_module.no_subclasses?(Foo)).to be false
      end
    end
  end

  describe :namespace_from_class_name do
    describe "when the provided class is not namespaced" do
      it "returns rubys top object" do
        expect(class_map_module.namespace_from_class_name("TestClass")).to be Object
      end
    end

    describe "when the provided class is namespaced within a module" do
      after(:each) do
        destroy_class MyModule
      end

      it "returns the expected module" do
        expect(class_map_module.namespace_from_class_name("MyModule::TestClass")).to be MyModule
      end
    end

    describe "when the provided class is namespaced within a multiple modules" do
      after(:each) do
        destroy_class MyModule::MyOtherModule
        destroy_class MyModule
      end

      it "returns the expected module" do
        expect(class_map_module.namespace_from_class_name("MyModule::MyOtherModule::TestClass")).to be MyModule::MyOtherModule
      end
    end
  end

  describe :create_class do
    describe "for a new class which is namespaced within Users" do
      after(:each) do
        destroy_class Users::User
        destroy_class Users
      end

      it "returns the expected active record class" do
        expect(class_map_module.create_class("Users::User", ApplicationRecord)).to be Users::User
      end

      describe "where the Users::User model has been successfully created" do
        before(:each) do
          # this will create the Users::User class, and make it available to the tests below
          class_map_module.create_class("Users::User", ApplicationRecord)
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(Users::User < ApplicationRecord).to be true
        end

        it "raises an error if the active record class already exists" do
          expect {
            class_map_module.create_class("Users::User", ApplicationRecord)
          }.to raise_error Platformer::ClassMap::ClassAlreadyExistsError
        end
      end
    end

    describe "for a new class which is not namespaced" do
      after(:each) do
        destroy_class Foo
      end

      it "returns the expected active record class" do
        expect(class_map_module.create_class("Foo", ApplicationRecord)).to be Foo
      end

      describe "where the Foo model has been successfully created" do
        before(:each) do
          # this will create the Foo class, and make it available to the tests below
          class_map_module.create_class("Foo", ApplicationRecord)
        end

        it "returns an active record class with the expected table_name_prefix" do
          expect(Foo.table_name_prefix).to eq("")
        end

        it "returns an active record class which extends ApplicationRecord" do
          expect(Foo < ApplicationRecord).to be true
        end

        it "raises an error if the active record class already exists" do
          expect {
            class_map_module.create_class("Foo", ApplicationRecord)
          }.to raise_error Platformer::ClassMap::ClassAlreadyExistsError
        end
      end
    end
  end
end
