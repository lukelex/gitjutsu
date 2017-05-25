require "singleton"
require_relative "./engine"

module Parsers
  class Javascript
    include ::Singleton

    TITLE = /\/{2}\s*TODO\s*:?\s*(?<title>.+)/i
    BODY = /\/{2}/

    def initialize
      @engine = Engine.new(TITLE, BODY)
    end

    def extract(contents)
      @engine.extract contents
    end
  end
end
