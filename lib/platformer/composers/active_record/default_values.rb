# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      # set all the default values (this is done within active record, they are not set as defaults in postgres)
      class DefaultValues < Parsers::Models::ForFields
        for_all_fields except: [:phone_number_field, :geo_point_field] do |column_name:, default:, active_record_class:|
          unless default.nil?
            default_value = default
            # set the default value within a before create callback
            active_record_class.before_validation on: :create do
              if public_send(column_name).nil?
                public_send "#{column_name}=", default_value
              end
            end
          end
        end

        for_dsl :phone_number_field do |prefix:, reader:, active_record_class:|
          default_dialing_code = reader.default&.dialing_code
          default_phone_number = reader.default&.phone_number

          unless default_dialing_code.nil? && default_phone_number.nil?
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            dialing_code_column_name = :"#{name_prepend}dialing_code"
            phone_number_column_name = :"#{name_prepend}phone_number"

            # set the default value within a before create callback
            active_record_class.before_validation on: :create do
              if public_send(dialing_code_column_name).nil?
                public_send "#{dialing_code_column_name}=", default_dialing_code
              end
              if public_send(phone_number_column_name).nil?
                public_send "#{phone_number_column_name}=", default_phone_number
              end
            end
          end
        end

        for_dsl :geo_point_field do |prefix:, reader:, active_record_class:|
          name_prepend = prefix.nil? ? "" : "#{prefix}_"

          column_name = "#{name_prepend}lonlat"

          default_longitude = reader.default&.longitude
          default_latitude = reader.default&.latitude

          unless default_longitude.nil? && default_latitude.nil?
            # set the default value within a before create callback
            active_record_class.before_validation on: :create do
              if public_send(column_name).nil?
                public_send "#{column_name}=", RGeo::Geographic.spherical_factory(srid: 4326).point(default_longitude, default_latitude)
              end
            end
          end
        end
      end
    end
  end
end
