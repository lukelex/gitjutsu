module Parsers
  class Engine
    def initialize(pattern)
      @pattern = pattern
    end

    def extract(contents)
      # receive file instead?
      lines = find_comment_lines(contents)
      lines.map(&method(:build))
    end

    private

    def find_comment_lines(contents)
      contents.split("\n")
        .each_with_index
        .select { |x, i| x =~ @pattern }
    end

    def build(line_and_number)
      @pattern.match(line_and_number.first) do |r|
        Todo.new \
          line: line_and_number.first,
          title: r["title"],
          line_number: line_and_number.last + 1,
          body: ""
      end
    end
  end

  class Todo < ClosedStruct
    def addition?
      !!(/^\+/ =~ line)
    end

    def removal?
      !!(/^\-/ =~ line)
    end
  end
end
