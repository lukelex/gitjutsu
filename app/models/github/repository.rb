module Github
  class Repository < ClosedStruct
    def create_hook(github_id:)
      Hooks.new(api: api).create name, analyse_url(github_id)
    end

    def remove_hook(hook_id:)
      Hooks.new(api: api).remove name, hook_id
    end

    def create_issue(title, body)
      api.create_issue full_name, title, body,
        labels: "todos"
    end

    def compare(start, endd)
      api.compare full_name, start, endd
    end

    def pull_request(number:, sha:)
      PullRequest.new \
        api: api,
        repo_name: full_name,
        number: number,
        sha: sha
    end

    private

    def analyse_url(param)
      Rails.application.routes.url_helpers.analyse_url(param)
    end
  end
end
