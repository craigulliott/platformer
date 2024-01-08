module Platformer
  module Generators
    module FromGrape
      module APIs
        class API < PlatformFile
          def initialize schema_name, definition
            table_name = if definition[:name].start_with? "#{schema_name}_"
              definition[:name].sub(/\A#{schema_name}_/, "")
            else
              definition[:name]
            end

            super :api, schema_name, table_name

            if definition[:name] == "users"
              add_section <<~RUBY
                # specific users can be found using either their UUID or username
                findable_by [:id, :username]
              RUBY
            end

            definition[:route_params]&.each do |route_param|
              # GET /resource/x
              if route_param[:get]
                add_section <<~GET
                  # GET /#{table_name}/x to return a specific #{table_name.singularize}
                  get
                GET
              end

              # DELETE /resource/x
              if route_param[:delete]
                undeletable = definition[:route_params].find { |rp| rp[:put] }&.dig(:update_options)&.find { |uo| uo[:deletable] }
                add_section <<~PUT
                  # DELETE /#{table_name}/x to delete a specific #{table_name.singularize}
                  delete#{undeletable ? " undeletable: true" : ""}
                PUT

              end
            end

            if definition[:get]
              lines = requires_and_optional definition[:filter_params], "filters"

              if definition[:paginate_params]
                lines << "pagination"
              end

              if (sort_by = definition[:sort_by_param])
                if sort_by.count == 1
                  lines << "sortable_by :#{sort_by.first}"
                elsif sort_by.count > 1
                  lines << "sortable_by [\n  :#{sort_by.join(",\n  :")}\n]"
                end
              end

              definition[:filter_options]&.each do |filter_option|
                filter_option.each do |key, value|
                  lines << case key
                  when :deletable
                    "action_field_filter :deletable"
                  when :publishable
                    "action_field_filter :publishable"
                  when :handleable
                    "action_field_filter :handleable"
                  when :claimable
                    "action_field_filter :claimable"
                  when :completable
                    "action_field_filter :completable"
                  when :acceptable
                    "action_field_filter :acceptable"
                  when :pinnable
                    "action_field_filter :pinnable"
                  when :usable
                    "action_field_filter :usable"
                  when :resolvable
                    "action_field_filter :resolvable"
                  when :cancelable
                    "action_field_filter :cancelable"
                  when :archivable
                    "action_field_filter :archivable"
                  when :failable
                    "action_field_filter :failable"
                  when :submittable
                    "action_field_filter :submittable"
                  when :revokable
                    "action_field_filter :revokable"
                  when :ignorable
                    "action_field_filter :ignorable"
                  when :approveable
                    "action_field_filter :approveable"
                  when :rejectable
                    "action_field_filter :rejectable"
                  when :agreeable
                    "action_field_filter :agreeable"
                  when :disagreeable
                    "action_field_filter :disagreeable"
                  else
                    raise "unexpected #{key}"
                  end
                end
              end

              add_section <<~GET
                # GET /#{table_name} to return a list of #{table_name}
                index do
                  #{indent lines.join("\n")}
                end
              GET

            end

            if definition[:post]
              lines = requires_and_optional definition[:create_params], "params"

              definition[:create_options]&.each do |create_option|
                create_option.each do |key, value|
                  # not needed in the new platform
                  next if key == :require_comment

                  case key
                  when :optional_relationships
                    value.each do |v|
                      lines << if v.is_a? String
                        "optional_relationship :#{v}"
                      else
                        "optional_relationship :#{v[:name]}"
                      end
                    end
                  when :required_relationships
                    value.each do |v|
                      lines << if v.is_a? String
                        "required_relationship :#{v}"
                      else
                        "required_relationship :#{v[:name]}"
                      end
                    end
                  when :deletable
                    lines << "action_field_settable :deletable"
                  when :publishable
                    lines << "action_field_settable :publishable"
                  when :handleable
                    lines << "action_field_settable :handleable"
                  when :claimable
                    lines << "action_field_settable :claimable"
                  when :completable
                    lines << "action_field_settable :completable"
                  when :acceptable
                    lines << "action_field_settable :acceptable"
                  when :pinnable
                    lines << "action_field_settable :pinnable"
                  when :usable
                    lines << "action_field_settable :usable"
                  when :resolvable
                    lines << "action_field_settable :resolvable"
                  when :cancelable
                    lines << "action_field_settable :cancelable"
                  when :archivable
                    lines << "action_field_settable :archivable"
                  when :failable
                    lines << "action_field_settable :failable"
                  when :submittable
                    lines << "action_field_settable :submittable"
                  when :revokable
                    lines << "action_field_settable :revokable"
                  when :ignorable
                    lines << "action_field_settable :ignorable"
                  when :approveable
                    lines << "action_field_settable :approveable"
                  when :rejectable
                    lines << "action_field_settable :rejectable"
                  when :agreeable
                    lines << "action_field_settable :agreeable"
                  when :disagreeable
                    lines << "action_field_settable :disagreeable"
                  else
                    raise "unexpected #{key}"
                  end
                end
              end

              add_section <<~GET
                # POST /#{table_name} to create a new #{table_name.singularize}
                create do
                  #{indent lines.join("\n")}
                end
              GET

            end

            definition[:route_params]&.each do |route_param|
              # note that GET /resource/x is missing here, because it is added near the top of the file
              # note that DELETE /resource/x is ommited here, it is added near the start of the file

              # PUT /resource/x
              if route_param[:put]
                lines = requires_and_optional route_param[:update_params], "params"

                route_param[:update_options]&.each do |update_option|
                  update_option.each do |key, value|
                    # not needed in the new platform
                    next if key == :require_comment
                    # not used here, its in the delete DSL instead
                    next if key == :deletable

                    case key
                    when :optional_relationships
                      value.each do |v|
                        lines << if v.is_a? String
                          "optional_relationship :#{v}"
                        else
                          "optional_relationship :#{v[:name]}"
                        end
                      end
                    when :required_relationships
                      value.each do |v|
                        lines << if v.is_a? String
                          "required_relationship :#{v}"
                        else
                          "required_relationship :#{v[:name]}"
                        end
                      end
                    when :publishable
                      lines << "action_field_settable :publishable"
                    when :handleable
                      lines << "action_field_settable :handleable"
                    when :claimable
                      lines << "action_field_settable :claimable"
                    when :completable
                      lines << "action_field_settable :completable"
                    when :acceptable
                      lines << "action_field_settable :acceptable"
                    when :pinnable
                      lines << "action_field_settable :pinnable"
                    when :usable
                      lines << "action_field_settable :usable"
                    when :resolvable
                      lines << "action_field_settable :resolvable"
                    when :cancelable
                      lines << "action_field_settable :cancelable"
                    when :archivable
                      lines << "action_field_settable :archivable"
                    when :failable
                      lines << "action_field_settable :failable"
                    when :submittable
                      lines << "action_field_settable :submittable"
                    when :revokable
                      lines << "action_field_settable :revokable"
                    when :ignorable
                      lines << "action_field_settable :ignorable"
                    when :approveable
                      lines << "action_field_settable :approveable"
                    when :rejectable
                      lines << "action_field_settable :rejectable"
                    when :agreeable
                      lines << "action_field_settable :agreeable"
                    when :disagreeable
                      lines << "action_field_settable :disagreeable"
                    else
                      raise "unexpected #{key}"
                    end
                  end
                end

                add_section <<~PUT
                  # PUT /#{table_name}/x to update a specific #{table_name.singularize}
                  update do
                    #{indent lines.join("\n")}
                  end
                PUT

              end

              # skip these, we don't want them
              if definition[:name] == "users" && route_param[:resources]&.any?
                route_param[:resources].delete :levels
                route_param[:resources].delete :public
              end

              # GET /resource/x/sub_resource
              route_param[:resources]&.values&.each do |resource_definition|
                name = resource_definition[:name]

                lines = requires_and_optional resource_definition[:filter_params], "filters"

                if resource_definition[:paginate_params]
                  lines << "pagination"
                end

                if (sort_by = resource_definition[:sort_by_param])
                  if sort_by.count == 1
                    lines << "sortable_by :#{sort_by.first}"
                  elsif sort_by.count > 1
                    lines << "sortable_by [\n  :#{sort_by.join(",\n  :")}\n]"
                  end
                end

                resource_definition[:filter_options]&.each do |filter_option|
                  filter_option.each do |key, value|
                    lines << case key
                    when :deletable
                      "action_field_filter :deletable"
                    when :publishable
                      "action_field_filter :publishable"
                    when :handleable
                      "action_field_filter :handleable"
                    when :claimable
                      "action_field_filter :claimable"
                    when :completable
                      "action_field_filter :completable"
                    when :acceptable
                      "action_field_filter :acceptable"
                    when :pinnable
                      "action_field_filter :pinnable"
                    when :usable
                      "action_field_filter :usable"
                    when :resolvable
                      "action_field_filter :resolvable"
                    when :cancelable
                      "action_field_filter :cancelable"
                    when :archivable
                      "action_field_filter :archivable"
                    when :failable
                      "action_field_filter :failable"
                    when :submittable
                      "action_field_filter :submittable"
                    when :revokable
                      "action_field_filter :revokable"
                    when :ignorable
                      "action_field_filter :ignorable"
                    when :approveable
                      "action_field_filter :approveable"
                    when :rejectable
                      "action_field_filter :rejectable"
                    when :agreeable
                      "action_field_filter :agreeable"
                    when :disagreeable
                      "action_field_filter :disagreeable"
                    else
                      raise "unexpected #{key}"
                    end
                  end
                end

                is_many = name == name.pluralize

                if lines.any?
                  add_section <<~GET
                    # GET /#{table_name}/x/#{name}
                    get_#{is_many ? "many" : "one"} :#{name} do
                      #{indent lines.join("\n")}
                    end
                  GET
                else
                  add_section <<~GET
                    # GET /#{table_name}/x/#{name}
                    get_#{is_many ? "many" : "one"} :#{name}
                  GET
                end
              end
            end
          end

          def requires_and_optional definition, namespace = nil
            lines = []
            if definition
              requires = definition[:requires]&.keys || []
              if requires.any?
                lines << "required_#{namespace} [\n  :#{requires.join(",\n  :")}\n]"
              end
              optional = definition[:optional]&.keys || []
              if optional.any?
                lines << "optional_#{namespace} [\n  :#{optional.join(",\n  :")}\n]"
              end
            end
            lines
          end
        end
      end
    end
  end
end
