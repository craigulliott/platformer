# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::InheritanceField do
  describe "for a new PhotoModel which defines a simple new model with an action field" do
    before(:each) do
      scaffold do
        table_for "Communication::TextMessage" do
          add_column :template, :text
        end
        model_for "Communication::TextMessage" do
          database :postgres, :primary
          schema :communication
          inheritance_field :template
        end
        model_for "Communication::TextMessages::Welcome", Communication::TextMessageModel do
        end
        model_for "Communication::TextMessages::HappyBirthday", Communication::TextMessageModel do
        end
      end
    end

    it "creates the expected attribute on the active record model" do
      text_message = Communication::TextMessages::Welcome.create!
      expect(text_message.template).to eq "Communication::TextMessages::Welcome"
    end

    it "is an STI model with the expected inheritance_column" do
      expect(Communication::TextMessages::Welcome.inheritance_column).to eq "template"
    end
  end
end
