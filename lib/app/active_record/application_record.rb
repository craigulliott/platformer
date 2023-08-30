class ApplicationRecord < ActiveRecord::Base
  # ApplicationRecord is always an abstract class
  self.abstract_class = true

  include Platformer::ActiveRecord::Coercions::UppercaseCoercions
  include Platformer::ActiveRecord::Coercions::LowercaseCoercions
  include Platformer::ActiveRecord::Coercions::TrimAndNullifyCoercions
  include Platformer::ActiveRecord::Coercions::ZeroToNullCoercions
  include Platformer::ActiveRecord::Coercions::EmptyJsonToNullCoercions
  # this coercion should come after other coercions which manipulate array values
  include Platformer::ActiveRecord::Coercions::RemoveNullArrayValuesCoercions
  # this coercion should come last, because other coercions may remove items
  include Platformer::ActiveRecord::Coercions::EmptyArrayToNullCoercions
end
