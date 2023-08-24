# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Functions
        class Function
          def self.set_definition defin
            @definition = defin
          end

          def self.definition
            @definition
          end

          def self.set_description desc
            @description = desc
          end

          def self.description
            @description
          end

          def self.function_name
            name.split("Platformer::Composers::Migrations::Functions::").last.gsub("::", "_").underscore.to_sym
          end
        end
      end
    end
  end
end
