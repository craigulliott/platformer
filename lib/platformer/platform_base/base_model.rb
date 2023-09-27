module Platformer
  class BaseModel < Base
    class InvalidModelClassName < StandardError
      def message
        "Model class names must end with 'Model'"
      end
    end

    describe_class <<~DESCRIPTION
      Create model definitions in platform/models
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description
    # Postgres Database Connections and Schema selection
    include Platformer::DSLs::Models::Database

    # install all our Field DSLs
    #
    include Platformer::DSLs::Models::PrimaryKey
    include Platformer::DSLs::Models::CoreTimestamps
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

    # soft deletable models (marks them as deleted instead of actually destroying the data)
    include Platformer::DSLs::Models::SoftDeletable

    # special fields and utilities
    include Platformer::DSLs::Models::StateMachine
    include Platformer::DSLs::Models::ActionField
    include Platformer::DSLs::Models::Positionable

    # optionally suppress the namespace when generating the query name
    # i.e. `user` instead of the default `users_user`
    include Platformer::DSLs::Models::SuppressNamespace

    # all model class names must end with "Model"
    def self.inherited subclass
      raise InvalidModelClassName unless subclass.name.end_with? "Model"
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

    def self.active_record_class
      get_equivilent_class ApplicationRecord
    end

    def self.schema_class
      get_equivilent_class BaseSchema
    end

    def self.graphql_type_class
      get_equivilent_class Types::BaseObject
    end
  end
end
