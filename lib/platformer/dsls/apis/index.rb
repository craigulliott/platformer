module Platformer
  module DSLs
    module APIs
      module Index
        def self.included klass
          klass.define_dsl :index do
            description <<~DESCRIPTION
              Expose a GET /resource endpoint for returning a list of the
              corresponding resource.
            DESCRIPTION

            add_unique_method :required_filters do
              description <<~DESCRIPTION
                An array of this models columns by which the list of resources
                should be filtered. These filters must be provided when accessing
                the resource.
              DESCRIPTION

              requires :columns, :symbol, array: true do
                description <<~DESCRIPTION
                  The list of column names for which filters will be exposed.
                DESCRIPTION
              end
            end

            add_unique_method :optional_filters do
              description <<~DESCRIPTION
                An array of this models columns by which the list of resources
                can be optionally filtered.
              DESCRIPTION

              requires :columns, :symbol, array: true do
                description <<~DESCRIPTION
                  The list of column names for which filters will be exposed.
                DESCRIPTION
              end
            end

            add_unique_method :pagination do
              description <<~DESCRIPTION
                Add pagination to this endpoint.
              DESCRIPTION
            end

            add_unique_method :sortable_by do
              description <<~DESCRIPTION
                An array of this models columns by which the list of resources
                can be optionally sorted.
              DESCRIPTION

              requires :columns, :symbol, array: true do
                description <<~DESCRIPTION
                  The list of column names for which sorting is enabled.
                DESCRIPTION
              end
            end

            add_method :action_field_filter do
              description <<~DESCRIPTION
                Add the ability to filter the results by the state of a particular action field
              DESCRIPTION

              requires :column, :symbol do
                description <<~DESCRIPTION
                  The action field to enable filtering by.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
