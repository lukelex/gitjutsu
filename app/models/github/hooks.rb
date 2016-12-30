module Github
  class Hooks < ClosedStruct
    def create(full_repo_name, callback_endpoint)
      api.create_hook \
        full_repo_name, "web",
        { url: callback_endpoint },
        { events: ["pull_request"], active: true }
    rescue Octokit::UnprocessableEntity => error
      if error.message.include? "Hook already exists"
        true
      else
        raise
      end
    end

    def remove(full_github_name, hook_id)
      api.remove_hook full_github_name, hook_id
    end
  end
end