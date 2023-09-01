class ImmutableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.new_record?
      return
    end

    if record.will_save_change_to_attribute?(attribute)
      record.errors.add(attribute, (options[:message] || "can not be changed"))
    end
  end
end
