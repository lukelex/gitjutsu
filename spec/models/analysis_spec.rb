require "rails_helper"

RSpec.describe Analysis do
  let(:pr_payload) do
    JSON.parse \
      File.read(File.join(__dir__, "../fixtures/pull_request_push.json"))
  end
  let(:master_payload) do
    JSON.parse \
      File.read(File.join(__dir__, "../fixtures/merge_on_master.json"))
  end

  it "validating with a pull request event" do
    subject.event = "pull_request"
    subject.payload = pr_payload

    expect(subject.valid?).to be true
  end

  it "validating a push event on master" do
    subject.event = "push"
    subject.payload = master_payload

    expect(subject.valid?).to be true
  end
end
