module Github
  class User
    def initialize(user)
      @user = user
    end

    delegate :github_token_scopes, to: :@user

    def has_access_to_private_repos?
      if github_token_scopes
        github_token_scopes.split(",").include? "repo"
      else
        false
      end
    end
  end
end
