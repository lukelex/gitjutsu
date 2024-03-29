# frozen_string_literal: true

require "singleton"
require_relative "./engine"

module Parsers
  class Javascript
    include ::Singleton

    COMMENT_SIGN = "//"
    TITLE = %r(\/{2}\s*TODO\s*:?\s*(?<title>.+))i
    BODY = %r((?!.*?TODO\s*:)\/{2}.*$)i
    EXTENSION = /.js$/i

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
