require "singleton"
require_relative "./engine"

module Parsers
  class Ruby
    include ::Singleton

    TITLE = /\#\s*TODO\s*(:)?\s*(?<title>.+)/i
    BODY = /\#/
    EXTENSION = /.rb$/

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
