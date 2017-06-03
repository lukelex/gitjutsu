require "singleton"

module Parsers
  class Unidentified
    include ::Singleton

    COMMENT_SIGN = nil

    def able?(_)
      true
    end

    def extract(*)
      []
    end
  end
end
