require "rspec"
require_relative "../../app/parsers/ruby"

RSpec.describe Parsers::Ruby do
  describe "#extract" do
    context "with a single comment" do
      it "isolated" do
        contents = <<~CODE
          # TODO: fix this!
        CODE
        comments = Parsers::Ruby.instance.extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
      end

      it "surrounded by code" do
        contents = <<~CODE
          def foo
          end

          # TODO: fix naming!
          def bar
          end
        CODE
        comments = Parsers::Ruby.instance.extract(contents)

        expect(comments.length).to eql 1
        comments.first.tap do |cmt|
          expect(cmt).is_a?(Parsers::Todo)
          expect(cmt.title).to eql "fix naming!"
          expect(cmt.line_number).to eql 4
        end
      end
    end

    context "multiple comments" do
      it "isolated" do
        contents = <<~CODE
          # TODO: fix this!
          # TODO: also look at this!
        CODE
        comments = Parsers::Ruby.instance.extract(contents)

        expect(comments.length).to eql 2
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
        expect(comments.last.title).to eql "also look at this!"
        expect(comments.last.line_number).to eql 2
      end

      it "surrounded by code" do
        contents = <<~CODE
          # TODO: fix naming!
          def foo
          end

          # TODO: also look at this!
          def bar
          end
        CODE
        comments = Parsers::Ruby.instance.extract(contents)

        expect(comments.length).to eql 2
        expect(comments.first.title).to eql "fix naming!"
        expect(comments.first.line_number).to eql 1
        expect(comments.last.title).to eql "also look at this!"
        expect(comments.last.line_number).to eql 5
      end
    end
  end
end
