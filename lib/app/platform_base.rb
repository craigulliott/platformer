class PlatformBase
  class NoTableStructureForModelError < StandardError
  end

  class NoDatabaseForModelError < StandardError
  end

  class NoActiveRecordClassForModelError < StandardError
  end

  class UnexpectedBaseError < StandardError
  end

  class EquivilentClassDoesNotExistError < StandardError
  end

  include DSLCompose::Composer

  # base documentation for the models which inherit from this clas
  def self.describe_class class_description
    @class_description = class_description
  end

  def self.class_description
    @class_description
  end

  # for swapping between classes, such as finding the Model class from it's
  # corresponding Schema class. If the corresponding model does not exist
  # then an error is thrown.
  warn "not tested"
  def self.get_equivilent_class target_base_class
    if target_base_class < self
      raise UnexpectedBaseError, "Refusing to to return the `#{target_base_class}` equivilent of this #{self}"
    end

    # the expected string at the end of the class name
    # unfortunately, we can not use a case statement to compare classes
    if target_base_class == ApplicationRecord
      target_append = ""
      namespace = ""

    elsif target_base_class == PlatformModel
      target_append = "Model"
      namespace = ""

    elsif target_base_class == PlatformSchema
      target_append = "Schema"
      namespace = ""

    elsif target_base_class == Types::BaseObject
      target_append = ""
      namespace = "Types::"

    else
      raise UnexpectedBaseError, "Unexpected base class `#{target_base_class}`"
    end

    # generate the expected class name based on the from_base and
    # setting the desired string at the end of the class name
    # unfortunately, we can not use a case statement to compare classes
    class_name = if self < PlatformModel
      namespace + name.gsub(/Model\Z/, target_append)
    elsif self < PlatformSchema
      namespace + name.gsub(/Schema\Z/, target_append)
    else
      raise UnexpectedBaseError, "Unexpected base class `#{self}`"
    end

    # assert the class already exists
    unless Object.const_defined? class_name
      raise EquivilentClassDoesNotExistError, "Class `#{class_name}` does not exist"
    end

    # turn the class name into a constant, and return it
    class_name.constantize
  end
end
