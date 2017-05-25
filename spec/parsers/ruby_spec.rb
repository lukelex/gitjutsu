require "rspec"
require_relative "../../app/models/parsers/ruby"

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

    context "multiple multiline comments" do
      it "followed by code" do
        contents = <<~CODE
          # TODO: multiline bitch!!
          # Write a regex for this!
          # I double dare you!!!
          def bar
          end

          # TODO: mooore multiline bitch!!
          # Write a more complex regex for this!
          # I triple dare you!!!
          def foo
          end
        CODE
        comments = Parsers::Ruby.instance.extract(contents)

        expect(comments.length).to eql 2
        comments.first.tap do |c|
          expect(c.title).to eql "multiline bitch!!"
          expect(c.line_number).to eql 1
          expect(c.body).to eql "# Write a regex for this!\n# I double dare you!!!"
        end
        comments.last.tap do |c|
          expect(c.title).to eql "mooore multiline bitch!!"
          expect(c.line_number).to eql 7
          expect(c.body).to eql "# Write a more complex regex for this!\n# I triple dare you!!!"
        end
      end
    end
  end
end
