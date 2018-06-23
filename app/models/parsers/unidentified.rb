# frozen_string_literal: true

require "singleton"

module Parsers
  class Unidentified
    include ::Singleton

    COMMENT_SIGN = nil

    def able?(*)
      true
    end

    def extract(*)
      []
    end
  end
end
