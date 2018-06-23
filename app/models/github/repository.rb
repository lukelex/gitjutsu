# frozen_string_literal: true

require "closed_struct"

module Github
  class Repository
    LABEL = "todos"

    def initialize(name:, api:)
      @name = name
      @api = api
      @file_cache = {}
    end

    def create_hook(github_id:)
      hooks.create \
        @name, analyse_url(github_id)
    end

    def toggle_hook(github_id:, hook_id:, active:)
      hooks.update \
        @name, hook_id,
        analyse_url(github_id), active
    end

    def remove_hook(hook_id:)
      hooks.remove @name, hook_id
    end

    def issues
      api.list_issues @name
    end

    def create_issue(title, body)
      api.create_issue @name, title, body, labels: LABEL
    end

    def close_issue(number)
      api.close_issue @name, number
    end

    def pull_request(number:, sha:)
      PullRequest.new \
        api: @api,
        repo_name: @name,
        number: number,
        sha: sha
    end

    def compare_files(before, after)
      compare(before, after)
        .files.map(&Github::File.method(:new))
    end

    private

    def hooks
      @_hooks ||= Hooks.new(api: @api)
    end

    def compare(start, endd)
      api.compare @name, start, endd
    end

    def analyse_url(param)
      Rails.application.routes.url_helpers.analyse_url(param)
    end
  end
end
