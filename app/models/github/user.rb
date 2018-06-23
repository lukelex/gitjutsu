# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module Github
  class User
    def initialize(user)
      @user = user
    end

    def access_to_private_repos?
      !!(@user.github_token_scopes&.split(",")&.include?("repo"))
    end
  end
end
