namespace :documentation do
  require "fileutils"

  task :clear_generated do
    generated_docs_path = Platformer.root "docs/generated"
    # clear the generated docs folder
    FileUtils.rm_rf(generated_docs_path)
    # recreate the folder
    FileUtils.mkdir(generated_docs_path)
  end

  desc "Generate the documentation for the Platformer DSLs"
  task generate: [:clear_generated] do
    # dynamically generate the documentation for all our DSLs
    base_path = Platformer.root "docs/generated"
    # set this to the position in the navigation bar where these docs should appear
    nav_order = 5
    # process each composer class (these are where our DSLs are defined)
    Platformer::Documentation.new(:models, Platformer::BaseModel, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:schemas, Platformer::BaseSchema, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:mutators, Platformer::BaseMutation, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:subscriptions, Platformer::BaseSubscription, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:presenters, Platformer::BasePresenter, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:policies, Platformer::BasePolicy, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:callbacks, Platformer::BaseCallback, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:jobs, Platformer::BaseJob, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:services, Platformer::BaseService, base_path, nav_order += 1).generate
    Platformer::Documentation.new(:apis, Platformer::BaseAPI, base_path, nav_order += 1).generate
  end
end
