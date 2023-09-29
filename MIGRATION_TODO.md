$ rake generate:from_db\[primary,codeverse_development,true,audit,i18n\] --trace
$ rake db:dynamic_migrate --trace

Display is a reserved word, its a standard lib ruby method. Change the enum from MissionStepInsertableModel and MissionStepModel from `display` to `display_type`

I18n is reserved, so skipping our I18n schema

remove belongs_to "I18n::TranslationModel" from SynthesizedClipModel

remove numeric_field :latitude and numeric_field :longitude from
  EmailEventModel
  ZipCodeModel
  PublicSessionModel
  AddressModel
  LocationModel
  AddressModel

AvailabilityInstanceModel belongs to availability and also has an availability column (these names collide)
rename `integer_field :attendees` to `integer_field :attending`
rename `integer_field :availability` to `integer_field :available`

rename all `as: :unknown` for associations