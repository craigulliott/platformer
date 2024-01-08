module Platformer
  module DSLs
    module APIs
      module Create
        def self.included klass
          klass.define_dsl :create do
            description <<~DESCRIPTION
              Expose a POST /resource endpoint for creating a new instance of the
              corresponding resource.
            DESCRIPTION

            add_unique_method :required_params do
              description <<~DESCRIPTION
                An array of this models fields which must be provided when creating
                the resource
              DESCRIPTION

              requires :columns, :symbol, array: true do
                description <<~DESCRIPTION
                  The list of field names which must be provided.
                DESCRIPTION
              end
            end

            add_unique_method :optional_params do
              description <<~DESCRIPTION
                An array of this models fields which can optionally be provided when creating
                the resource
              DESCRIPTION

              requires :columns, :symbol, array: true do
                description <<~DESCRIPTION
                  The list of field names which can be provided.
                DESCRIPTION
              end
            end

            add_method :required_relationship do
              description <<~DESCRIPTION
                Add an assoociation of the corresponding model (such as has_one) which must
                be provided when creating the resource.
              DESCRIPTION

              requires :column, :symbol do
                description <<~DESCRIPTION
                  The name of the association.
                DESCRIPTION
              end
            end

            add_method :optional_relationship do
              description <<~DESCRIPTION
                Add an assoociation of the corresponding model (such as has_one) which may
                optionally be provided when creating the resource.
              DESCRIPTION

              requires :column, :symbol do
                description <<~DESCRIPTION
                  The name of the association.
                DESCRIPTION
              end
            end

            add_method :action_field_settable do
              description <<~DESCRIPTION
                Add the ability to set the state of a particular action field
              DESCRIPTION

              requires :column, :symbol do
                description <<~DESCRIPTION
                  The action field which can have it's value set.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
