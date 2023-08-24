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

  # we cache the resulting structure object here so that the
  # other parsers can more easily access it
  def self.set_table_structure table_structure
    @table_structure = table_structure
  end

  def self.table_structure
    if @table_structure.nil?
      raise NoTableStructureForModelError, "No table structure object has been added for class `#{self.class}`"
    end
    @table_structure
  end

  # we cache the resulting database object here so that the
  # other parsers can more easily access it
  def self.set_configured_database configured_database
    @configured_database = configured_database
  end

  def self.configured_database
    if @configured_database.nil?
      raise NoDatabaseForModelError, "No database object has been added for class `#{self.class}`"
    end
    @configured_database
  end

  # we cache the resulting ActiveRecord class here so that the
  # other parsers can more easily access it
  def self.set_active_record_class klass
    @active_record_class = klass
  end

  def self.active_record_class
    if @active_record_class.nil?
      raise NoActiveRecordClassForModelError, "No active record class has been added for class `#{self.class}`"
    end
    @active_record_class
  end
end
