require "class_spec_helper"

module Scaffold
  # A DSL for use in before hooks to scaffold the platformer
  #
  # Example use:
  #
  # scaffold do
  #
  #   table_for "Users::User" do
  #     add_column :my_char, :char
  #   end
  #
  #   model_for "Users::User" do
  #     database :postgres, :primary
  #     schema :users
  #     char_field :my_char
  #   end
  #
  #   schema_for "Users::User" do
  #     # root node causes this to be added as a root level query in the schema
  #     root_collection do
  #       by_exact_string :my_char
  #     end
  #     # name this model `user` instead of `users_user`
  #     suppress_namespace
  #     # expose the my_char field
  #     fields [
  #       :my_char
  #     ]
  #   end
  #
  #   # you can also use the methods `callback_for`, `job_for`, `mutation_for`, `policy_for` and `service_for`
  # end

  def create_class fully_qualified_class_name, base_class = nil, &block
    class_spec_helper.create_class fully_qualified_class_name, base_class, &block
  end

  def destroy_class klass
    class_spec_helper.destroy_class klass
  end

  def scaffold &block
    # clear out and reset graphql
    recreate_graphql_schema
    # create the classes/composers
    yield
    # rerun all the composers
    rerun_composers
    # reinitialize the graphql schema
    Schema.initialize!
  end

  def destroy_dynamically_created_classes
    @to_destroy&.each do |name|
      destroy_active_record_class name
      destroy_graphql_type_class name
    end
    class_spec_helper.remove_all_dynamically_created_classes
    @to_destroy = []
  end

  private

  def class_spec_helper
    @class_spec_helper ||= ClassSpecHelper.new
  end

  # check for, and destroy the ActiveRecord class
  def destroy_active_record_class name
    if Object.const_defined? name
      class_spec_helper.destroy_class name.constantize
    end
  end

  # check for, and destroy the GraphQL Type class
  def destroy_graphql_type_class name
    graphql_type_class_name = "Types::#{name}"
    if Object.const_defined? graphql_type_class_name
      class_spec_helper.destroy_class graphql_type_class_name.constantize
    end
  end

  def remember_class_name_to_destroy_later name
    @to_destroy ||= []
    @to_destroy << name
  end

  def rerun_composers
    DSLCompose::Parser.rerun_all
  end

  # DSL for creating a Callback definition
  def callback_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Callback", Platformer::BaseCallback, &block
  end

  # DSL for creating a Job definition
  def job_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Job", Platformer::BaseJob, &block
  end

  # DSL for creating a Model definition
  def model_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Model", Platformer::BaseModel, &block
  end

  # DSL for creating a GraphQL Mutation definition
  def mutation_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Mutation", Platformer::BaseMutation, &block
  end

  # DSL for creating a Policy definition
  def policy_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Policy", Platformer::BasePolicy, &block
  end

  # DSL for creating a GraphQL Schema definition
  def schema_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Schema", Platformer::BaseSchema, &block
  end

  # DSL for creating a Service definition
  def service_for name, &block
    remember_class_name_to_destroy_later name

    class_spec_helper.create_class "#{name}Service", Platformer::BaseService, &block
  end

  # DSL for creating a postgres table
  def table_for name, &block
    remember_class_name_to_destroy_later name

    name_parts = name.split("::")
    if name_parts.count == 1
      schema_name = :public
      table_name = name_parts[0].underscore.pluralize.to_sym
    elsif name_parts.count == 2
      schema_name = name_parts[0].underscore.to_sym
      table_name = name_parts[1].underscore.pluralize.to_sym
    else
      raise "`#{name}` is not supported, this helper only allows for maximum of one level deep for namespacing"
    end

    if schema_name != :public
      unless pg_helper.schema_exists? schema_name
        pg_helper.create_schema schema_name
      end
    end

    pg_helper.create_model schema_name, table_name, &block
  end
end
