class PlatformBase
  class NoTableStructureForModelError < StandardError
  end

  class NoDatabaseForModelError < StandardError
  end

  class NoActiveRecordClassForModelError < StandardError
  end

  include DSLCompose::Composer

  # base documentation for the models which inherit from this clas
  def self.describe_class class_description
    @class_description = class_description
  end

  def self.class_description
    @class_description
  end
end
