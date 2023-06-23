# frozen_string_literal: true

module Platformer
  class Composer
    class ClassDoesNotUseDSLComposeError < StandardError
    end

    # when provided with a class which has DSLCompose added to it, such
    # as ApplicationModel, this method will execute the provided block
    # once for every child class of the provided class. A common use of this
    # method would be to find all classes of a particular type (such as
    # models or callback definitions) and dynamically create something
    # for each of them
    def self.for_each_child_class klass, &block
      unless klass.respond_to? :dsls
        raise ClassDoesNotUseDSLCompose
      end
      if block
        klass.dsls.executions_by_class.each do |k, dsl|
          yield k
        end
      else
        warn "no block provided"
      end
    end

    def self.for_each klass, dsl_name, &block
      # todo
    end
  end
end
