# frozen_string_literal: true

require "closed_struct"
require_relative "todo"

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
        .select { |x, _i| @title_pattern.match(x) }
    end

    def find_body_lines(all_lines, comment_lines)
      bodies = {}
      comment_lines.each do |comment_line|
        first_after       = comment_line.last + 1
        last_line         = all_lines.length - 1
        lines_after_title = all_lines[first_after..last_line]

        bodies[comment_line] = lines_after_title
          .take_while { |line| @body_pattern.match?(line) }
          .join("\n")
      end
      bodies
    end

    def build(line_and_number, body)
      @title_pattern.match(line_and_number.first) do |r|
        Todo.new \
          line: line_and_number.first,
          title: r["title"].strip,
          line_number: line_and_number.last + 1,
          body: body
      end
    end
  end
end
