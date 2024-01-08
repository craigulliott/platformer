module Serializers
  class Base
    include JSONAPI::Serializer

    def meta
      if object && object.respond_to?(:deleted?)
        {
          deletable: true,
          deleted_at: (object.deleted_at && object.deleted_at.utc.iso8601)
        }
      else
        {
          deletable: false
        }
      end
    end

    def base_url
      "https://#{Platformer.domain_name}"
    end

    def self.datetime_attribute name, with_zone = false
      add_attribute name do
        if time = object.send(name)
          with_zone ? time.iso8601 : time.utc.iso8601
        end
      end
    end

    def self.float_attribute name
      add_attribute name do
        object.send(name).try(:to_f)
      end
    end

    def self.date_attribute name
      add_attribute name do
        if date = object.send(name)
          date.to_s(:api_date)
        end
      end
    end

    def self.money_attribute name
      add_attribute name do
        if amount = object.send(name)
          number_to_currency amount
        end
      end
    end

    # models such as user have scopes like Users::Account, these models all have a _name helper
    # which returns a value appropriate for API responses. I.e. 'Users::Account' comes back
    #  as 'account'
    def self.sti_attribute name
      add_attribute name do
        object.send("#{name}_name")
      end
    end

    def self.ip_attribute name
      add_attribute name do
        if object.send(name).present?
          object.send(name).to_s
        end
      end
    end

    def self.subnet_attribute name
      add_attribute name do
        if object.send(name).present?
          object.send(name).subnet_mask
        end
      end
    end

    def self.file_attribute name
      add_attribute name do
        if object.send(name).present?
          object.send(name).url(:original)
        end
      end
    end

    def self.image_attribute name, style = :default
      add_attribute "#{name}#{(style == :default) ? "" : style}" do
        if object.send(name).present?
          object.send(name).url(style)
        end
      end
    end

    def self.image_attribute_2x name, style = :default
      add_attribute "#{name}#{(style == :default) ? "" : style}_2x" do
        if object.send(name).present?
          object.send(name).url("#{style}_2x".to_sym)
        end
      end
    end

    def self.phone_attribute options = {}
      if prefix = options[:column_prefix]
        phone_number_column_name = "#{prefix}_phone_number".to_sym
        dialing_code_column_name = "#{prefix}_dialing_code".to_sym
      else
        phone_number_column_name = (options[:column_name] || "phone_number").to_sym
        dialing_code_column_name = (options[:dialing_code_column_name] || "dialing_code").to_sym
      end

      # the simple string format of the dialing code, i.e. US = '1' and UK = '44'
      add_attribute dialing_code_column_name do
        object.send dialing_code_column_name
      end

      # the simple string format of the phone number without the international code i.e. '2674418233'
      add_attribute phone_number_column_name do
        dialing_code = object.send dialing_code_column_name
        object.send(phone_number_column_name)
      end

      # the international formated version of the phone number i.e. '+1 (267) 441-8233'
      add_attribute "#{phone_number_column_name}_international_formatted" do
        if phone_number = object.send(phone_number_column_name)
          dialing_code = object.send dialing_code_column_name
          full_number = Phony.normalize phone_number, cc: dialing_code
          Phony.format full_number, format: :international
        end
      end

      # the locally formated version of the phone number i.e. '(267) 441-8233'
      add_attribute "#{phone_number_column_name}_formatted" do
        if phone_number = object.send(phone_number_column_name)
          dialing_code = object.send dialing_code_column_name
          full_number = Phony.normalize phone_number, cc: dialing_code
          Phony.format full_number, format: :national
        end
      end
    end

    def self.percentage_attribute name
      add_attribute name do
        if number = object.send(name)
          number_to_percentage number
        end
      end
    end

    # By default, attribute names are dasherized per the spec naming recommendations, but
    # we prefer to keep them underscores so that it's the same from front to back
    def format_name(attribute_name)
      attribute_name.to_s
    end

    # The opposite of format_name.
    def unformat_name(attribute_name)
      attribute_name.to_s
    end

    # the API doesnt support these links, so we remove/hide them from the response
    # http://api.domain.localhost:3000/projects/bddde5d9-a185-49a8-bab2-22088df7e5ac/relationships/user
    def relationship_self_link(attribute_name)
      nil
    end

    def current_user
      context && context[:current_user]
    end

    def current_organization
      context && context[:current_user]
    end
  end
end
