require "singleton"
require_relative "./engine"

module Parsers
  class Ruby
    include ::Singleton

    TITLE = /\#\s*TODO\s*(:)?\s*(?<title>.+)/i
    BODY = /\#/

    def initialize
      @engine = Engine.new(TITLE, BODY)
    end

    def extract(contents)
      @engine.extract contents
    end
  end
end
