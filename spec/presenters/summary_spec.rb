require "rails_helper"

RSpec.describe Summary do
  describe "#to_s" do
    let(:added_todo) { ClosedStruct.new(addition?: true, removal?: false) }
    let(:removed_todo) { ClosedStruct.new(addition?: false, removal?: true) }

    it "given only additions" do
      summary = described_class.new([
        ["my_file.rb", [added_todo, added_todo]]
      ])

      summary.to_s.tap do |txt|
        expect(txt).to include("2 added")
        expect(txt).not_to include("0 removed")
      end
    end

    it "given only removals" do
      summary = described_class.new([
        ["my_file.rb", [removed_todo, removed_todo]]
      ])

      summary.to_s.tap do |txt|
        expect(txt).not_to include("0 added")
        expect(txt).to include("2 removed")
      end
    end

    it "given both additions & removals" do
      summary = described_class.new([
        ["my_file.rb", [added_todo, added_todo, removed_todo]]
      ])

      summary.to_s.tap do |txt|
        expect(txt).to include("2 added")
        expect(txt).to include("1 removed")
      end
    end

    it "given neither additions nor removals" do
      summary = described_class.new([
        ["my_file.rb", []]
      ])

      summary.to_s.tap do |txt|
        expect(txt).not_to include("0 added")
        expect(txt).not_to include("0 removed")
        expect(txt).to eql "Nothing to do"
      end
    end
  end
end
