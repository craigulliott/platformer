module Platformer
  module DSLs
    module Models
      module Fields
        module GeoPointField
          def self.included klass
            klass.define_dsl :geo_point_field do
              namespace :fields
              title "Add an Email field to your Model"
              description <<~DESCRIPTION
                Add an lonlat geo point field to this model. This will be represented
                in the database as a postgis point (`postgis.geography(Point,4326)`).
                The default field name is `lonlat`, and a prefix can be optionally added
                to this name if more than one geo point are to be added to this model.
              DESCRIPTION

              # Arguments
              #
              # an optional prefix for this fields name
              optional :prefix, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  An optional prefix to use for the name of this field. This prefix
                  will be prepended to the lonlat column name which backs this field,
                  and to the presenter methods, graphql queries and mutations.
                DESCRIPTION
              end

              import_shared :allow_null

              # add an optional attribute which can be used to
              # denote this as an array of lonlats
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of lonlats, and
                  will be backed by a `postgis.geography(Point,4326)[]` type
                  in PostgreSQL.
                DESCRIPTION
              end

              add_unique_method :default do
                requires :longitude, :float do
                  validate_less_than 180
                  validate_greater_than(-180)
                end
                requires :latitude, :float do
                  validate_less_than 90
                  validate_greater_than(-90)
                end
              end

              # Common methods which are shared between fields
              import_shared :database_default
              import_shared :empty_array_to_null_coercion
              import_shared :field_description
              import_shared :immutable_validators
            end
          end
        end
      end
    end
  end
end
