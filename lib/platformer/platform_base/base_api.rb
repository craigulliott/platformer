module Platformer
  class BaseAPI < Base
    describe_class <<~DESCRIPTION
      Create api definitions in platform/apis
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # install all our JSON API DSLs
    #
    include Platformer::DSLs::APIs::FindableBy
    include Platformer::DSLs::APIs::Fields
    include Platformer::DSLs::APIs::Get
    include Platformer::DSLs::APIs::Index
    include Platformer::DSLs::APIs::Create
    include Platformer::DSLs::APIs::Update
    include Platformer::DSLs::APIs::Delete
    include Platformer::DSLs::APIs::GetOne
    include Platformer::DSLs::APIs::GetMany

    # all model class names must end with "API"
    def self.inherited subclass
      super
      validate_naming_and_hierachy_conventions subclass, "API"
    end
  end
end
