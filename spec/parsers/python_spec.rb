require "spec_helper"
require_relative "../../app/models/parsers/python"

RSpec.describe Parsers::Python do
  describe "#able?" do
    it "with a python file name" do
      expect(able?("test.py")).to be true
    end

    it "with a js file name" do
      expect(able?("test.js")).to be false
    end
  end

  describe "#extract" do
    context "with a single comment" do
      it "isolated" do
        contents = <<~CODE
          # TODO: fix this!
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
      end

      it "surrounded by code" do
        contents = <<~CODE
          def foo(self, name):


          # TODO: fix naming!
          def bar(self):
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        comments.first.tap do |cmt|
          expect(cmt).is_a?(Parsers::Todo)
          expect(cmt.title).to eql "fix naming!"
          expect(cmt.line_number).to eql 4
        end
      end

      it "at the end of the line" do
        contents = <<~CODE
          [[1, "a"], [2, "b"]].to_h # TODO: write a test for this later
        CODE

        comments = extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "write a test for this later"
      end

      it "at the end of the line with another one right below it" do
        contents = <<~CODE
          [[1, "a"], [2, "b"]].to_h # TODO: write a test for this later
          # TODO: this is a completely different comment
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
          # TODO: fix this!
          # TODO: also look at this!
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
          # TODO: fix naming!
          def foo(self)

          # TODO: also look at this!
          def bar(self, code)
        CODE
        comments = extract(contents)

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
          def bar(self, bla)

          # TODO: mooore multiline bitch!!
          # Write a more complex regex for this!
          # I triple dare you!!!
          def foo(self, ble)
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
    Parsers::Python.instance.able?(filename)
  end

  def extract(contents)
    Parsers::Python.instance.extract(contents)
  end
end
