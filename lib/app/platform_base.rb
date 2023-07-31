class PlatformBase
  include DSLCompose::Composer

  def self.class_description
    @class_description
  end

  def self.describe_class class_description
    @class_description = class_description
  end
end
