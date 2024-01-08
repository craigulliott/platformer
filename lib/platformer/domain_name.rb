module Platformer
  module DomainName
    class DomainNameNotSetError < StandardError
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def domain_name
        if ENV["DOMAIN_NAME"].nil?
          raise DomainNameNotSetError, "Domain Name is not set. Set the DOMAIN_NAME environemnt variable or add a value for ENV['DOMAIN_NAME'] in your platform's `config/boot.rb` file"
        end
        ENV["DOMAIN_NAME"]
      end
    end
  end
end
