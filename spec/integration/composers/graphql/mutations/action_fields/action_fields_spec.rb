# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::ActionFields do
  describe "for a Project model with an publish action_field and a publish mutation" do
    before(:each) do
      scaffold do
        table_for "Project" do
          add_column :unpublished, :boolean, null: true
          add_column :published_at, :timestamp, null: true
        end

        model_for "Project" do
          database :postgres, :primary
          action_field :published, action_name: :publish
        end

        mutation_for "Project" do
          action :publish
        end

        schema_for "Project" do
          fields [:published]
        end
      end
    end

    it "executes an appropriate query successfully" do
      project = Project.create!
      global_id = project.to_gid_param

      results = Schema.execute <<~QUERY
        mutation {
          publishProject(
            input: {
              id: "#{global_id}"
            }
          ) {
            errors {
              path
              message
            }
            project {
              published
            }
          }
        }
      QUERY

      expect(results["data"]["publishProject"]["project"]["published"]).to be true
      expect(results["data"]["publishProject"]["errors"]).to eql []

      project.reload
      expect(project.unpublished).to be_nil
    end
  end
end
