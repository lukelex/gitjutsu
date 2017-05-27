require "singleton"

module Parsers
  class Unidentified
    include ::Singleton

    def able?(_)
      true
    end

    def extract(*)
      []
    end
  end
end
