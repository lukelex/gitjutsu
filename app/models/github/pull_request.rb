# frozen_string_literal: true

module Github
  class PullRequest
    def initialize(api:, repo_name:, number:, sha:)
      @api = api
      @repo_name = repo_name
      @number = number
      @sha = sha
    end

    def production_files
      files.reject(&:test_file?)
    end

    def set_status(state, description, target_url: nil)
      @api.create_status \
        @repo_name, @sha, state,
        context: "GitDoer",
        description: description,
        target_url: target_url
    end

    private

    def files
      @api.pull_request_files(@repo_name, @number)
        .map(&File.method(:new))
    end
  end
end
