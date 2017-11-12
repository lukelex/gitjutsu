# frozen_string_literal: true

require "singleton"
require_relative "./engine"

module Parsers
  class Python
    include ::Singleton

    COMMENT_SIGN = "#"
    TITLE = /\#\s*TODO\s*(:)?\s*(?<title>.+)/i
    BODY = /(?!.*?TODO\s*:)#.*$/i
    EXTENSION = /.py$/i

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
