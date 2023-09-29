# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::DefaultValues do
  describe "for a new UserModel with a field that has a default value" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :foo, :text
        end
        model_for "User" do
          database :postgres, :primary
          text_field :foo do
            default "Hi There"
          end
        end
      end
    end

    it "sets the expected default value for the column" do
      user = User.create!
      expect(user.foo).to eq "Hi There"
    end
  end

  describe "for a new UserModel with a phone_number field that has a default value" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :dialing_code, :text
          add_column :phone_number, :text
        end
        model_for "User" do
          database :postgres, :primary
          phone_number_field do
            default "DIAL_CODE_1", "1234567890"
          end
        end
      end
    end

    it "sets the expected default value for the column" do
      user = User.create!
      expect(user.dialing_code).to eq "DIAL_CODE_1"
      expect(user.phone_number).to eq "1234567890"
    end
  end

  describe "for a new UserModel with a geo point field that has a default value" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :lonlat, :"postgis.geography(Point,4326)"
        end
        model_for "User" do
          database :postgres, :primary
          geo_point_field do
            default 123.456, 69.123
          end
        end
      end
    end

    it "sets the expected default value for the column" do
      user = User.create!
      expect(user.lonlat.to_s).to eq "POINT (123.456 69.123)"
    end
  end
end
