require "singleton"
require_relative "./engine"

module Parsers
  class Javascript
    include ::Singleton

    TITLE = /\/{2}\s*TODO\s*:?\s*(?<title>.+)/i
    BODY = /\/{2}/
    EXTENSION = /.js$/

    def initialize
      @engine = Engine.new(TITLE, BODY)
    end

    def able?(filename)
      EXTENSION.match? filename.to_s
    end

    def extract(contents)
      @engine.extract contents
    end
  end
end
