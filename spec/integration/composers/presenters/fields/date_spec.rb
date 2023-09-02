# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Date do
  describe "for a new UserModel which defines a simple new model with a date field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_date, :date
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          date_field :my_date
        end
      end
    end

    subject {
      user = Users::User.new(my_date: "1984-07-14")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.my_date).to eq "1984-07-14" }
    end
  end
end
