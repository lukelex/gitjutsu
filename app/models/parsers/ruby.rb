require "singleton"
require_relative "./engine"

module Parsers
  class Ruby
    include ::Singleton

    COMMENT_SIGN = "#".freeze
    TITLE = %r(\#\s*TODO\s*(:)?\s*(?<title>.+))i
    BODY = %r((?!.*?TODO\s*:)#.*$)i
    EXTENSION = %r(.rb$)i

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
