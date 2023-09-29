require "platformer"

namespace :app do
  desc "Include this task as a depencency from other tadks when you want access to your models, services and other parts of your platform."
  task :environment do
    require_relative Platformer.root "config/application"
  end
end

# this alias is for convenience, add :environment as a dependency in your
# tasks if you want to access the composed platform, all your models etc.
#
# Example:
#
# task my_task: :environment do
#    ...
# end
task environment: "app:environment"
