module Github
  class PullRequest
    def initialize(api:, repo_name:, number:, sha:)
      @api, @repo_name, @number, @sha = api, repo_name, number, sha
    end

    def files
      @api.pull_request_files(@repo_name, @number)
      # @api.pull_request_files(@repo_name, @number).map do |file|
      #   CommitFile.new \
      #     filename: file.filename,
      #     commit: ""
      # end
    end

    def set_status(state, description, target_url: nil)
      @api.create_status \
        @repo_name, @sha, state,
        context: "GitDoer",
        description: description,
        target_url: target_url
    end
  end
end
