module Platformer
  class BaseCallback < Base
    include Platformer::DSLs::Callbacks::AfterStageChange
  end
end
