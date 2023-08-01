class ApplicationRecord < ActiveRecord::Base
  # ApplicationRecord is always an abstract class
  self.abstract_class = true

  # Connect to the default postgres database
  establish_connection(Platformer::Databases.server(:postgres, :primary).default_database.active_record_configuration)

  include Platformer::ActiveRecord::Coercions::UppercaseCoercions
  include Platformer::ActiveRecord::Coercions::LowercaseCoercions
  include Platformer::ActiveRecord::Coercions::TrimAndNullifyCoercions
  include Platformer::ActiveRecord::Coercions::ZeroToNullCoercions
end
