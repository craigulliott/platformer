# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        class ZeroToNullCoercions < DSLCompose::Parser
          # install all the zero_to_null coercions for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:integer_field, :float_field, :double_field, :numeric_field] do |name:|
              for_method :zero_to_null do
                description <<-DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will convert `#{name}` into null if it has a value equal to 0.
                DESCRIPTION

                # add the before_validation callback to the active record class
                model.before_validation do
                  value = send(name)
                  if value == 0
                    send "#{name}=", nil
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_zero_to_null_coercion name
              end
            end
          end
        end
      end
    end
  end
end
