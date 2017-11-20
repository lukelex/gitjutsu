# frozen_string_literal: true

module Github
  class PullRequest
    PENDING = "Analyzing..."
    ERROR   = "Errored"

    def initialize(api:, repo_name:, number:, sha:)
      @api = api
      @repo_name = repo_name
      @number = number
      @sha = sha
    end

    def production_files
      files.reject(&:test_file?)
    end

    def analyzing(live)
      set_status(:pending, PENDING) if live

      yield.tap do |result|
        summarize(result) if live
      end
    ensure
      set_status(:success, ERROR) if live
    end

    private

    def summarize(result)
      set_status :success, Summary.new(result)
    end

    def set_status(state, description, target_url: nil)
      @api.create_status \
        @repo_name, @sha, state,
        context: "Codetags",
        description: description,
        target_url: target_url
    end

    def files
      @api.pull_request_files(@repo_name, @number)
        .map(&File.method(:new))
    end
  end
end
