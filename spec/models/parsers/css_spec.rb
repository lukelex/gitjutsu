require "spec_helper"
require_relative "../../../app/models/parsers/css"

RSpec.describe Parsers::CSS do
  describe "#able?" do
    it "with a css file name" do
      expect(able?("test.css")).to be true
    end

    it "with a js file name" do
      expect(able?("test.js")).to be false
    end
  end

  describe "#extract" do
    context "with a single comment" do
      it "isolated" do
        contents = <<~CODE
          /* TODO: fix this! */
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
      end

      it "surrounded by code" do
        contents = <<~CODE
          html {
            color: pink;
          }

          /* TODO: fix naming! */
          .body {
            display: none;
          }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        comments.first.tap do |cmt|
          expect(cmt).is_a?(Parsers::Todo)
          expect(cmt.title).to eql "fix naming!"
          expect(cmt.line_number).to eql 5
        end
      end

      it "at the end of the line" do
        contents = <<~CODE
          section { border: none; } /* TODO: write a test for this later */
        CODE

        comments = extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "write a test for this later"
      end

      it "at the end of the line and another one right below it" do
        contents = <<~CODE
          section { border: none; } /* TODO: write a test for this later */
          /* TODO: this is a completely different comment */
        CODE

        comments = extract(contents)

        expect(comments.length).to eql 2
        comments.first.tap do |cmt|
          expect(cmt.title).to eql "write a test for this later"
          expect(cmt.body).to eql ""
        end
        expect(comments.last.title).to eql "this is a completely different comment"
      end
    end

    context "multiple comments" do
      it "isolated" do
        contents = <<~CODE
          /* TODO: fix this! */
          /* TODO: also look at this! */
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 2
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
        expect(comments.last.title).to eql "also look at this!"
        expect(comments.last.line_number).to eql 2
      end

      it "surrounded by code" do
        contents = <<~CODE
          /* TODO: fix naming! */
          section { border: none; }

          /* TODO: also look at this! */
          html { font: comicsans; }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 2
        expect(comments.first.title).to eql "fix naming!"
        expect(comments.first.line_number).to eql 1
        expect(comments.last.title).to eql "also look at this!"
        expect(comments.last.line_number).to eql 4
      end
    end

    context "multiple multiline comments" do
      it "followed by code" do
        contents = <<~CODE
          /* TODO: multiline bitch!!
             Write a regex for this!
             I double dare you!!! */
          .dnone { display: none; }

          /*
            TODO: mooore multiline bitch!!
            Write a more complex regex for this!
            I triple dare you!!!
          */
          center { text-align: center; }
        CODE
        comments = extract(contents)

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

  def able?(filename)
    Parsers::CSS.instance.able?(filename)
  end

  def extract(contents)
    Parsers::CSS.instance.extract(contents)
  end
end
