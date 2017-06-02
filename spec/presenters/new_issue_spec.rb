require "rails_helper"
require "closed_struct"

RSpec.describe NewIssue do
  describe "#body" do
    let(:repo) { ClosedStruct.new(name: "test-repo") }
    let(:file) { "test-file"}

    context "given a full TODO" do
      it do
        todo = ClosedStruct.new(body: "test-body", line_number: 17) do
          def unique_id(**)
            "123abc"
          end
        end
        issue = described_class.new(repo, file, todo)

        issue.body.tap do |txt|
          expect(txt).to include("Description:")
          expect(txt).to match(/\[\/{2}\]: # \(gitdoer-metadata: 123abc\)/)
        end
      end
    end

    context "given a TODO without a description" do
      it do
        todo = ClosedStruct.new(body: "", line_number: 1) do
          def unique_id(**)
            "123abc"
          end
        end
        issue = described_class.new(repo, file, todo)

        issue.body.tap do |txt|
          expect(txt).not_to include("Description:")
        end
      end
    end
  end
end
