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
          expect(txt).to match(/\[\/{2}\]: # \(codetags-metadata: 123abc\)/)
        end
      end

      it "with a description" do
        description = <<~DESC
          + # It should test wether we&#39;re correctly adding or removing
          + # them on both existing and non-existing scenarios
          - // aside from everything
        DESC
        todo = ClosedStruct.new(body: description, line_number: 17) do
          def unique_id(**)
            "123abc"
          end
        end
        issue = described_class.new(repo, file, todo)

        expect(issue.body).to eq <<~ISSUE
        [test-file:17](https://github.com/test-repo/blob/master/test-file#L17)

          Description:
          &gt; It should test wether we&amp;#39;re correctly adding or removing
        &gt; them on both existing and non-existing scenarios
        &gt; aside from everything

        [//]: # (codetags-metadata: 123abc)
        ISSUE
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
