# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::InheritanceField do
  describe "for an sti model with a default column name" do
    before(:each) do
      scaffold do
        model_for "Communication::TextMessage" do
          database :postgres, :primary
          schema :communication
        end
        model_for "Communication::TextMessages::Welcome", Communication::TextMessageModel do
        end
        model_for "Communication::TextMessages::HappyBirthday", Communication::TextMessageModel do
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:communication).table(:text_messages)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:type)).to be true }

      it { expect(subject.column(:type).data_type).to be :"communication.text_messages_types" }

      it { expect(subject.column(:type).null).to be false }

      it { expect(subject.column(:type).default).to be_nil }
    end
  end

  describe "for an sti model with a custom column name" do
    before(:each) do
      scaffold do
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

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:communication).table(:text_messages)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:template)).to be true }

      it { expect(subject.column(:template).data_type).to be :"communication.text_messages_templates" }

      it { expect(subject.column(:template).null).to be false }

      it { expect(subject.column(:template).default).to be_nil }
    end
  end
end
