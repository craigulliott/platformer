class PlatformModel
  class InvalidModelClassName < StandardError
    def message
      "Model class names must end with 'Model'"
    end
  end

  include DSLCompose::Composer
  # Postgres Database Connections and Schema selection
  include Platformer::DSLs::Models::PostgresConnection
  # install all our Field DSLs
  include Platformer::DSLs::Models::Fields::ArrayField
  include Platformer::DSLs::Models::Fields::BooleanField
  include Platformer::DSLs::Models::Fields::DateField
  include Platformer::DSLs::Models::Fields::DateTimeField
  include Platformer::DSLs::Models::Fields::EmailField
  include Platformer::DSLs::Models::Fields::EnumField
  include Platformer::DSLs::Models::Fields::FloatField
  include Platformer::DSLs::Models::Fields::IntegerField
  include Platformer::DSLs::Models::Fields::JSONField
  include Platformer::DSLs::Models::Fields::PhoneNumberField
  include Platformer::DSLs::Models::Fields::StringField
  # install all our relationship DSLs
  include Platformer::DSLs::Models::Relationships::BelongsTo
  include Platformer::DSLs::Models::Relationships::HasMany
  include Platformer::DSLs::Models::Relationships::HasOne
  # install our GraphQL DSLs
  include Platformer::DSLs::Models::GraphQL::RootNode

  # all model class names must end with "Model"
  def self.inherited subclass
    raise InvalidModelClassName unless subclass.name.end_with? "Model"
  end
end
