class PlatformModel < PlatformBase
  class InvalidModelClassName < StandardError
    def message
      "Model class names must end with 'Model'"
    end
  end

  describe_class <<~DESCRIPTION
    Create model definitions in app/model to describe your records
  DESCRIPTION

  # Add descriptions to your classes
  include Platformer::DSLs::Description
  # Postgres Database Connections and Schema selection
  include Platformer::DSLs::Models::Database

  # install all our Field DSLs
  #
  # uuid
  include Platformer::DSLs::Models::Fields::UuidField
  # numeric fields
  include Platformer::DSLs::Models::Fields::IntegerField
  include Platformer::DSLs::Models::Fields::FloatField
  include Platformer::DSLs::Models::Fields::DoubleField
  include Platformer::DSLs::Models::Fields::NumericField
  # boolean
  include Platformer::DSLs::Models::Fields::BooleanField
  # date and time
  include Platformer::DSLs::Models::Fields::DateField
  include Platformer::DSLs::Models::Fields::DateTimeField
  # text
  include Platformer::DSLs::Models::Fields::TextField
  include Platformer::DSLs::Models::Fields::CharField
  include Platformer::DSLs::Models::Fields::CitextField
  # enums / constants
  include Platformer::DSLs::Models::Fields::EnumField
  include Platformer::DSLs::Models::Fields::CurrencyField
  include Platformer::DSLs::Models::Fields::CountryField
  include Platformer::DSLs::Models::Fields::LanguageField
  # json
  include Platformer::DSLs::Models::Fields::JsonField
  # network
  include Platformer::DSLs::Models::Fields::IpAddressField
  include Platformer::DSLs::Models::Fields::MacAddressField
  include Platformer::DSLs::Models::Fields::CidrField
  # special fields
  include Platformer::DSLs::Models::Fields::PhoneNumberField
  include Platformer::DSLs::Models::Fields::EmailField

  # install all our relationship DSLs
  include Platformer::DSLs::Models::Associations::BelongsTo
  include Platformer::DSLs::Models::Associations::HasMany
  include Platformer::DSLs::Models::Associations::HasOne

  # install our GraphQL DSLs
  include Platformer::DSLs::Models::GraphQL::RootNode

  # all model class names must end with "Model"
  def self.inherited subclass
    raise InvalidModelClassName unless subclass.name.end_with? "Model"
  end
end
