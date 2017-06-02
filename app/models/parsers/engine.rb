require "closed_struct"
require "openssl"

module Parsers
  class Engine
    def initialize(title_pattern, body_pattern)
      @title_pattern = title_pattern
      @body_pattern = body_pattern
    end

    def extract(contents)
      all_lines = contents.split("\n")

      lines = find_comment_lines(all_lines)
      bodies = find_body_lines(all_lines, lines)

      lines.map { |l| build(l, bodies[l]) }
    end

    private

    def find_comment_lines(code_lines)
      code_lines
        .each_with_index
        .select { |x, i| x =~ @title_pattern }
    end

    def find_body_lines(all_lines, comment_lines)
      bodies = {}
      comment_lines.each do |comment_line|
        lines_after_title = all_lines[(comment_line.last+1)..(all_lines.length-1)]

        bodies[comment_line] = lines_after_title
          .take_while { |line| line =~ @body_pattern } # TODO: use @body_pattern.match?(line)
          .join("\n")
      end
      bodies
    end

    def build(line_and_number, body)
      @title_pattern.match(line_and_number.first) do |r|
        Todo.new \
          line: line_and_number.first,
          title: r["title"],
          line_number: line_and_number.last + 1,
          body: body
      end
    end
  end

  class Todo < ClosedStruct
    class << self
      def calculate_id(filename, fields)
        OpenSSL::HMAC.hexdigest OpenSSL::Digest.new("sha1"), filename, fields.join
      end
    end

    def addition?
      /^\+/.match? line
    end

    def removal?
      /^\-/.match? line
    end

    def unique_id(filename:)
      self.class.calculate_id filename, to_h.values_at(:line_number, :line)
    end
  end
end
