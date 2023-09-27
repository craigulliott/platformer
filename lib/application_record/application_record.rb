require_relative "install_method"

require_relative "validators/immutable_once_set_validator"
require_relative "validators/immutable_validator"
require_relative "validators/not_nil_validator"

require_relative "coercions/empty_array_to_null_coercion"
require_relative "coercions/empty_json_to_null_coercion"
require_relative "coercions/lowercase_coercion"
require_relative "coercions/remove_null_array_values_coercion"
require_relative "coercions/trim_and_nullify_coercion"
require_relative "coercions/uppercase_coercion"
require_relative "coercions/zero_to_null_coercion"

class ApplicationRecord < ActiveRecord::Base
  # ApplicationRecord is always an abstract class
  self.abstract_class = true

  # functionality to dynamically install methods onto activerecord classes
  include Platformer::ActiveRecord::InstallMethod

  # rails GlobalID provides a unique ID for every object, and ability to easily load
  # objects based on these IDs. We use it in conjunction with GraphQL to make our server
  # relay compatible
  include GlobalID::Identification

  # coercions to fix and sanitize data automtically
  include Platformer::ActiveRecord::Coercions::UppercaseCoercion
  include Platformer::ActiveRecord::Coercions::LowercaseCoercion
  include Platformer::ActiveRecord::Coercions::TrimAndNullifyCoercion
  include Platformer::ActiveRecord::Coercions::ZeroToNullCoercion
  include Platformer::ActiveRecord::Coercions::EmptyJsonToNullCoercion
  # this coercion should come after other coercions which manipulate array values
  include Platformer::ActiveRecord::Coercions::RemoveNullArrayValuesCoercion
  # this coercion should come last, because other coercions may remove items
  include Platformer::ActiveRecord::Coercions::EmptyArrayToNullCoercion

  def delete
    throw "delete is disabled by default"
  end

  def destroy
    throw "destroy is disabled by default"
  end
end
