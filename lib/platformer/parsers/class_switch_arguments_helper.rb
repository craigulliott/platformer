module Platformer
  module Parsers
    module ClassSwitchArgumentsHelper
      class ArgumentNotAvailableError < StandardError
      end

      def self.resolve_arguments desired_arg_names, child_class
        final_args = {}
        desired_arg_names.each do |arg_name|
          # all the arguments which can be passed to the block
          case arg_name

          when :callback_definition_class
            final_args[:callback_definition_class] = child_class.callback_definition_class

          when :job_definition_class
            final_args[:job_definition_class] = child_class.job_definition_class

          when :model_definition_class
            final_args[:model_definition_class] = child_class.model_definition_class

          when :mutation_definition_class
            final_args[:mutation_definition_class] = child_class.mutation_definition_class

          when :policy_definition_class
            final_args[:policy_definition_class] = child_class.policy_definition_class

          when :presenter_definition_class
            final_args[:presenter_definition_class] = child_class.presenter_definition_class

          when :schema_definition_class
            final_args[:schema_definition_class] = child_class.schema_definition_class

          when :service_definition_class
            final_args[:service_definition_class] = child_class.service_definition_class

          when :subscription_definition_class
            final_args[:subscription_definition_class] = child_class.subscription_definition_class

          when :active_record_class
            # get the equivilent ActiveRecord class (based on naming conventions)
            # will raise an error if the ActiveRecord class does not exist
            final_args[:active_record_class] = child_class.active_record_class

          when :presenter_class
            # get the equivilent Presenter class (based on naming conventions)
            # will return nil if the desired Presenter class does not exist
            final_args[:presenter_class] = child_class.presenter_class

          when :graphql_type_class
            # get the equivilent GraphQL Type class (based on naming conventions)
            # will return nil if the desired Type class does not exist
            final_args[:graphql_type_class] = child_class.graphql_type_class

          when :schema_reader
            final_args[:schema_reader] = DSLReaders::Schema.new(child_class.schema_definition_class)

          end
        end
        # return the final args
        final_args
      end
    end
  end
end
