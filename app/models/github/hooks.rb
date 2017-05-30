require "closed_struct"

module Github
  class Hooks < ClosedStruct
    EVENTS = ["push", "pull_request"]

    def create(repo_name, callback_endpoint)
      api.create_hook repo_name, "web",
        default_config.merge(url: callback_endpoint),
        { events: EVENTS, active: true }
    rescue Octokit::UnprocessableEntity => error
      if error.message.include? "Hook already exists"
        true
      else
        raise
      end
    end

    def update(repo_name, hook_id, callback_endpoint, active)
      api.edit_hook repo_name, hook_id, "web",
        default_config.merge(url: callback_endpoint),
        { events: EVENTS, active: active }
    end

    def remove(repo_name, hook_id)
      api.remove_hook repo_name, hook_id
    end

    private

    def default_config
      { content_type: "json", secret: ENV["SECRET_TOKEN"] }
    end
  end
end
