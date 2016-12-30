module Github
  class Repository < ClosedStruct
    def create_hook(repo_id:)
      Hooks.new(api: api).create full_name, "http://localhost:3000/analyses"
    end

    def remove_hook(hook_id:)
      Hooks.new(api: api).remove full_name, hook_id
    end

    def pr_files(pr_number:)
      api.pull_request_files full_name, pr_number
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
