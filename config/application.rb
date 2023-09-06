# frozen_string_literal: true

ENV["PLATFORMER_ROOT"] ||= File.expand_path("../", __dir__)

require "platformer"

GlobalID.app = :platformer

Platformer.initialize!
