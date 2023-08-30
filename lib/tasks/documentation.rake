namespace :documentation do
  require "fileutils"

  task :clear_generated do
    generated_docs_path = File.expand_path("docs/generated/")
    # clear the generated docs folder
    FileUtils.rm_rf(generated_docs_path)
    # recreate the folder
    FileUtils.mkdir(generated_docs_path)
  end

  desc "Generate the documentation for the Platformer DSLs"
  task generate: [:clear_generated] do
    # dynamically generate the documentation for all our DSLs
    base_path = File.expand_path("docs/generated/")
    # process each composer class (these are where our DSLs are defined)
    Platformer::Documentation.new(:models, BaseModel, base_path).generate
    Platformer::Documentation.new(:schemas, BaseSchema, base_path).generate
  end
end
