# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Queries::RootNode do
  describe "for a User which has many Hobbies, where Hobbies are in Categories" do
    before(:each) do
      scaffold do
        #
        # Postgres tables
        #
        table_for "Users::User" do
          add_column :name, :text
          add_column :date_of_birth, :date
          add_column :favorite_hobby_id, :uuid
        end
        table_for "Hobbies::UserHobby" do
          add_column :user_id, :uuid
          add_column :hobby_id, :uuid
        end
        table_for "Hobbies::Hobby" do
          add_column :category_id, :uuid
          add_column :name, :text
        end
        table_for "Hobbies::Category" do
          add_column :name, :text
        end

        #
        # Model Definitions
        #
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          suppress_namespace

          primary_key
          has_many "Hobbies::UserHobbyModel"
          belongs_to "Hobbies::HobbyModel", as: :favorite_hobby
          text_field :name
          date_field :date_of_birth do
            allow_null
          end
        end
        model_for "Hobbies::UserHobby" do
          database :postgres, :primary
          schema :hobbies

          primary_key
          belongs_to "Users::UserModel"
          belongs_to "Hobbies::HobbyModel"
        end
        model_for "Hobbies::Hobby" do
          database :postgres, :primary
          schema :hobbies
          suppress_namespace

          primary_key
          has_many "Hobbies::UserHobbyModel"
          belongs_to "Hobbies::CategoryModel"
          text_field :name
        end
        model_for "Hobbies::Category" do
          database :postgres, :primary
          schema :hobbies

          primary_key
          has_many "Hobbies::HobbyModel"
          text_field :name
        end

        #
        # GraphQL Mutations
        #
        mutation_for "Users::User" do
          update do
            fields [:name, :date_of_birth]
            # node_field :favorite_hobby
          end
        end
        mutation_for "Hobbies::UserHobby" do
          update do
            # node_field :user
            # node_field :hobby
          end
        end
        mutation_for "Hobbies::Hobby" do
          update do
            fields [:name]
            # node_field :category
          end
        end
        mutation_for "Hobbies::Category" do
          update do
            fields [:name]
          end
        end

        #
        # GraphQL Schemas
        #
        schema_for "Users::User" do
          # root node causes this to be added as a root level query in the schema
          root_node do
            by_id
          end
          fields [:name, :date_of_birth]
          node_field "Hobbies::HobbyModel", association_name: :favorite_hobby
        end
        schema_for "Hobbies::UserHobby" do
          # node_field "Users::UserModel"
          # node_field "Hobbies::HobbyModel"
        end
        schema_for "Hobbies::Hobby" do
          fields [:name]
          # node_field "Hobbies::CategoryModel"
        end
        schema_for "Hobbies::Category" do
          fields [:name]
        end
      end
    end

    # create some test data
    let(:user) { Users::User.create! name: "Katy", date_of_birth: "1984-05-08" }

    # hobby categories
    let(:water_category) { Hobbies::Category.create! name: "Water" }
    let(:land_category) { Hobbies::Category.create! name: "Land" }

    # water hobbies
    let(:sailing) { water_category.hobbies.create! name: "Sailing" }
    let(:freediving) { water_category.hobbies.create! name: "Freediving" }

    # land hobbies
    let(:hiking) { land_category.hobbies.create! name: "Hiking" }
    let(:gaming) { land_category.hobbies.create! name: "Gaming" }

    before(:each) do
      # associate the hobbies with the user
      user.user_hobbies.create hobby: sailing
      user.user_hobbies.create hobby: freediving
      user.user_hobbies.create hobby: hiking
      user.user_hobbies.create hobby: gaming

      user.favorite_hobby = freediving
      user.save!
    end

    context "a simple query on the user root node" do
      subject {
        Schema.execute <<~QUERY
          {
            user(id: "#{user.id}") {
              name
            }
          }
        QUERY
      }

      it { expect(subject["data"]["user"]["name"]).to eq "Katy" }
    end

    context "a query on the user root node which includes the favorite hobby" do
      subject {
        Schema.execute <<~QUERY
          {
            user(id: "#{user.id}") {
              name
              favoriteHobby {
                name
              }
            }
          }
        QUERY
      }

      it { expect(subject["data"]["user"]["name"]).to eq "Katy" }

      it { expect(subject["data"]["user"]["favoriteHobby"]["name"]).to eq "Freediving" }
    end
  end
end
