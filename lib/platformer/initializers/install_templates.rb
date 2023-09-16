# install all the validation templates
module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          {
            greater_than: GreaterThan,
            greater_than_or_equal_to: GreaterThanOrEqualTo,
            less_than: LessThan,
            less_than_or_equal_to: LessThanOrEqualTo,
            equal_to: EqualTo,
            trimmed_and_nullified: TrimmedAndNullified,
            zero_nulled: ZeroNulled,
            uppercase: Uppercase,
            lowercase: Lowercase,
            minimum_length: MinimumLength,
            maximum_length: MaximumLength,
            length_is: LengthIs,
            exclusion: Exclusion,
            inclusion: Inclusion,
            is_value: IsValue,
            format: Format
          }.each do |name, subclass|
            DynamicMigrations::Postgres::Generator::Validation.add_template name, subclass
          end
        end

        module Triggers
          {
            immutable: Immutable,
            immutable_once_set: ImmutableOnceSet,
            trimmed_and_nullified_array: TrimmedAndNullifiedArray
          }.each do |name, subclass|
            DynamicMigrations::Postgres::Generator::Trigger.add_template name, subclass
          end
        end
      end
    end
  end
end
