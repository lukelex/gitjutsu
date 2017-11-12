require "rspec"
require "closed_struct"
require_relative "../../../app/models/github/user"

RSpec.describe Github::User do
  describe "#access_to_private_repos?" do
    context "without scopes" do
      let(:user) { ClosedStruct.new(github_token_scopes: nil) }
      let(:github_user) { described_class.new(user) }

      it { expect(github_user.access_to_private_repos?).to be false }
    end

    context "with existing 'repo' scopes" do
      let(:user) { ClosedStruct.new(github_token_scopes: "repo,user:email") }
      let(:github_user) { described_class.new(user) }

      it { expect(github_user.access_to_private_repos?).to be true }
    end
  end
end
