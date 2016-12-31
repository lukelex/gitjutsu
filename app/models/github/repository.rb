module Github
  class Repository < ClosedStruct
    def create_hook(hook_id:)
      Hooks.new(api: api).create full_name,
        Rails.application.routes.url_helpers.analyse_url(hook_id)
    end

    def remove_hook(hook_id:)
      Hooks.new(api: api).remove full_name, hook_id
    end

    def pull_request(number:, sha:)
      PullRequest.new \
        api: api,
        repo_name: full_name,
        number: number,
        sha: sha
    end
  end
end
