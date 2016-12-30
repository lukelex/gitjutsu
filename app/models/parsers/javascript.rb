require "singleton"
require_relative "./engine"

module Parsers
  class Javascript
    include ::Singleton

    COMMENT_REGEX = /\/\/\s*TODO\s*(:)?\s*(?<title>.+)/i

    def initialize
      @engine = Engine.new(COMMENT_REGEX)
    end

    def extract(contents)
      @engine.extract contents
    end
  end
end
