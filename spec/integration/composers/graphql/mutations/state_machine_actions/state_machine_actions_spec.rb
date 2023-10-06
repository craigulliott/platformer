# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::StateMachineActions do
  describe "for a Project model with an publish action_field and a publish mutation" do
    before(:each) do
      scaffold do
        table_for "Projects::Project" do
          add_column :state, :text
        end

        model_for "Projects::Project" do
          database :postgres, :primary
          schema :projects
          # publishProject instead of publishProjectsProject
          suppress_namespace

          state_machine do
            state :new
            state :published

            action :publish, to: :published
          end
        end

        mutation_for "Projects::Project" do
          state_machine_action :publish
        end

        schema_for "Projects::Project" do
          fields [:state]
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
              id: "#{global_id}"
            }
          ) {
            errors {
              path
              message
            }
            project {
              state
            }
          }
        }
      QUERY

      expect(results["data"]["publishProject"]["project"]["state"]["published"]).to eq "published"
      expect(results["data"]["publishProject"]["errors"]).to eql []

      project.reload
      expect(project.state).to eq "published"
    end
  end
end
