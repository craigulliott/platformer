module Platformer
  module Services
    module GraphQL
      class EnumCreator
        # todo: not tested
        class EnumAlreadyExistsError < StandardError
        end

        attr_reader :enum_class

        def initialize enum_name, model_public_name = nil
          @enum_name = enum_name
          @model_public_name = model_public_name
        end

        def find_or_create values
          if enum_exists?
            # return the constant
            enum_class_name.constantize
          else
            create values
          end
        end

        private

        # where values is { value: description, value2: description2 }
        def create values
          # build the class
          @enum_class = raw_enum_class
          # populate the values
          values.each do |value|
            @enum_class.value value
          end
          # return it
          @enum_class
        end

        private

        def enum_exists?
          Object.const_defined? enum_class_name
        end

        # create the enum class
        def raw_enum_class
          if enum_exists?
            raise EnumAlreadyExistsError, "Constant #{enum_class_name} already exists"
          end
          ClassMap.create_class enum_class_name, ::Types::BaseEnum
        end

        # generate a name like "Types::UsersBadgeStatusEnum" from a status enum on "Users::Badges"
        def enum_class_name
          # if a models public name was provided, then namespace the enum
          if @model_public_name
            "Types::#{@model_public_name.to_s.classify}#{@enum_name.to_s.classify}Enum"

          # if no public name was provided to scope this enum to a particular model, then this
          # enum is shared across the whole system
          else
            "Types::#{@enum_name.to_s.classify}Enum"
          end
        end
      end
    end
  end
end
