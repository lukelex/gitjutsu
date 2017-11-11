require_relative "./ruby"
require_relative "./javascript"
require_relative "./unidentified"

module Parsers
  module All
    extend self

    PARSERS = [
      Ruby,
      Javascript,
      Unidentified,
      Python
    ].freeze

    def extract_from(file)
      PARSERS.map(&:instance)
        .find { |parser| parser.able?(file.filename) }
        .extract(file.patch)
    end

    def comment_signs
      PARSERS.map { |parser| parser::COMMENT_SIGN }.compact
    end
  end
end
