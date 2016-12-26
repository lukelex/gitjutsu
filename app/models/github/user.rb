require "active_support/core_ext/module/delegation"

module Github
  class User
    def initialize(user)
      @user = user
    end

    def has_access_to_private_repos?
      !!(github_token_scopes&.split(",")&.include?("repo"))
    end

    private

    delegate :github_token_scopes, to: :@user

    def github
      Github::Api.new github_token
    end
  end
end
