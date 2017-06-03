require "spec_helper"
require_relative "../../../app/models/github/file"
require "closed_struct"

RSpec.describe Github::File do
  describe "#test_file?" do
    let(:test_files) { ClosedStruct.new(filename: "bla_spec.rb") }
    let(:production_file) { ClosedStruct.new(filename: "bla_specification.rb") }

    it "given test files" do
      file = described_class.new(test_files)

      expect(file.test_file?).to be true
    end

    it "given production file" do
      file = described_class.new(production_file)

      expect(file.test_file?).to be false
    end
  end
end
