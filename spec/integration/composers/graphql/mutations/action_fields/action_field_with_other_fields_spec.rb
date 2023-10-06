# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::ActionFields do
  describe "for a Project model with an publish action_field and a publish mutation which allows updating other fields" do
    before(:each) do
      scaffold do
        table_for "Projects::Project" do
          add_column :unpublished, :boolean, null: true
          add_column :published_at, :timestamp, null: true
          add_column :foo, :text, null: true
          add_column :bar, :text, null: true
        end

        model_for "Projects::Project" do
          database :postgres, :primary
          schema :projects
          # publishProject instead of publishProjectsProject
          suppress_namespace

          action_field :published, action_name: :publish
          text_field :foo, allow_null: true do
          end
          text_field :bar, allow_null: true do
          end
        end

        mutation_for "Projects::Project" do
          action :publish do
            fields [:foo, :bar]
          end
        end

        schema_for "Projects::Project" do
          fields [:published, :foo, :bar]
        end
      end
    end

    it "executes an appropriate query successfully" do
      project = Projects::Project.create!
      global_id = project.to_gid_param

      results = Schema.execute <<~QUERY
        mutation {
          publishProject(
            input: {
              id: "#{global_id}",
              foo: "foo_val",
              bar: "bar_val"
            }
          ) {
            errors {
              path
              message
            }
            project {
              published,
              foo,
              bar
            }
          }
        }
      QUERY

      expect(results["data"]["publishProject"]["project"]["published"]).to be true
      expect(results["data"]["publishProject"]["project"]["foo"]).to eq "foo_val"
      expect(results["data"]["publishProject"]["project"]["bar"]).to eq "bar_val"
      expect(results["data"]["publishProject"]["errors"]).to eql []

      project.reload
      expect(project.unpublished).to be_nil
    end
  end
end
