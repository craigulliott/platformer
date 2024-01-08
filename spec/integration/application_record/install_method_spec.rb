# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::ActiveRecord::InstallMethod do
  describe "for a new active record model which includes this module" do
    before(:each) do
      db_config = default_database_configuration

      create_class "User", ActiveRecord::Base do
        # Connect to the default postgres database
        establish_connection(db_config)
        # include the module
        include Platformer::ActiveRecord::InstallMethod
      end
    end

    describe :install_method do
      it "installs the instance method without raising an error" do
        expect {
          User.install_method :foo do
            123
          end
        }.to_not raise_error
      end

      describe "after an instance method has been installed" do
        before(:each) do
          User.install_method :foo do
            123
          end

          it "executes as expected" do
            expect(User.new.foo).to eq(123)
          end

          it "raises an error if the method already exists" do
            expect {
              User.install_method :foo do
                123
              end
            }.to raise_error Platformer::ActiveRecord::InstallMethod::MethodAlreadyExistsError
          end
        end
      end
    end
  end
end
