module Platformer
  module DSLs
    module APIs
      module GetOne
        def self.included klass
          klass.define_dsl :get_one do
            description <<~DESCRIPTION
              Expose a GET /resource/id/association endpoint for returning a specific resource
              which is associated with the corresponding model.
            DESCRIPTION

            requires :association_name, :symbol do
              description <<~DESCRIPTION
                The name of the corresponding has_one or belongs_to assciation for the
                corresponding model.
              DESCRIPTION
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
          end
        end
      end
    end
  end
end
