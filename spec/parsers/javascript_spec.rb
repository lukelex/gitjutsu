require "rspec"
require_relative "../../app/models/parsers/javascript"

RSpec.describe Parsers::Javascript do
  describe "#able?" do
    it "with a ruby file name" do
      expect(able?("test.js")).to be true
    end

    it "with a js file name" do
      expect(able?("test.rb")).to be false
    end
  end

  describe "#extract" do
    context "with a single comment" do
      it "isolated" do
        contents = <<~CODE
          // TODO: fix this!
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        expect(comments.first.title).to eql "fix this!"
        expect(comments.first.line_number).to eql 1
      end

      it "surrounded by code" do
        contents = <<~CODE
          function() {
            alert(1);
          }

          // TODO: fix naming!
          function() { }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        comments.first.tap do |cmt|
          expect(cmt).is_a?(Parsers::Todo)
          expect(cmt.title).to eql "fix naming!"
          expect(cmt.line_number).to eql 5
        end
      end
    end

    context "multiple comments" do
      it "isolated" do
        contents = <<~CODE
          // TODO: fix this!
          // TODO: also look at this!
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
          // TODO: fix naming!
          function() { }

          // TODO: also look at this!
          function() { }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 2
        expect(comments.first.title).to eql "fix naming!"
        expect(comments.first.line_number).to eql 1
        expect(comments.last.title).to eql "also look at this!"
        expect(comments.last.line_number).to eql 4
      end
    end

    context "single multiline comment" do
      it "followed by code" do
        contents = <<~CODE
          // TODO: multiline bitch!!
          // Write a regex for this!
          // I double dare you!!!
          function() { }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 1
        comments.first.tap do |c|
          expect(c.title).to eql "multiline bitch!!"
          expect(c.line_number).to eql 1
          expect(c.body).to eql "// Write a regex for this!\n// I double dare you!!!"
        end
      end
    end

    context "multiple multiline comments" do
      it "followed by code" do
        contents = <<~CODE
          // TODO: multiline bitch!!
          // Write a regex for this!
          // I double dare you!!!
          function() { }

          // TODO: mooore multiline bitch!!
          // Write a more complex regex for this!
          // I triple dare you!!!
          function() { }
        CODE
        comments = extract(contents)

        expect(comments.length).to eql 2
        comments.first.tap do |c|
          expect(c.title).to eql "multiline bitch!!"
          expect(c.line_number).to eql 1
          expect(c.body).to eql "// Write a regex for this!\n// I double dare you!!!"
        end
        comments.last.tap do |c|
          expect(c.title).to eql "mooore multiline bitch!!"
          expect(c.line_number).to eql 6
          expect(c.body).to eql "// Write a more complex regex for this!\n// I triple dare you!!!"
        end
      end
    end
  end

  def able?(filename)
    Parsers::Javascript.instance.able?(filename)
  end

  def extract(contents)
    Parsers::Javascript.instance.extract(contents)
  end
end
