# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      # set all the default values (this is done within active record, they are not set as defaults in postgres)
      class DefaultValues < Parsers::AllModels::ForFields
        for_all_fields except: :phone_number_field do |column_names:, default:, active_record_class:|
          column_names.each do |column_name|
            default_value = default
            # set the default value within a before create callback
            active_record_class.before_validation on: :create do
              if public_send(column_name).nil?
                public_send "#{column_name}=", default_value
              end
            end
          end
        end
      end
    end
  end
end
