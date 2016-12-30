require "octokit"

module Github
  class Api
    ORGANIZATION_TYPE = "Organization".freeze

    attr_reader :file_cache, :token

    def initialize(token)
      @token = token
      @file_cache = {}
    end

    def client
      @client ||= Octokit::Client.new(access_token: token, auto_paginate: true)
    end

    def scopes
      client.scopes(token).join ","
    end

    def repos
      client.repos
    end

    def repo(repo_name)
      client.repository repo_name
    end

    def add_pull_request_comment(options)
      client.create_pull_request_comment \
        options[:commit].repo_name,
        options[:pull_request_number],
        options[:comment],
        options[:commit].sha,
        options[:filename],
        options[:patch_position]
    end

    def pull_request_comments(full_repo_name, pull_request_number)
      client.pull_request_comments(full_repo_name, pull_request_number)
    end

    def pull_request_files(full_repo_name, number)
      client.pull_request_files(full_repo_name, number)
    end

    def file_contents(full_repo_name, filename, sha)
      file_cache["#{full_repo_name}/#{sha}/#{filename}"] ||=
        client.contents(full_repo_name, path: filename, ref: sha)
    end

    def create_pending_status(full_repo_name, sha, description)
      create_status \
        repo: full_repo_name,
        sha: sha,
        state: "pending",
        description: description
    end

    def create_success_status(full_repo_name, sha, description)
      create_status \
        repo: full_repo_name,
        sha: sha,
        state: "success",
        description: description
    end

    def create_error_status(full_repo_name, sha, description, target_url = nil)
      create_status \
        repo: full_repo_name,
        sha: sha,
        state: "error",
        description: description,
        target_url: target_url
    end

    def add_collaborator(repo_name, username)
      client.add_collaborator \
        repo_name,
        username,
        accept: "application/vnd.github.ironman-preview+json"
    end

    def remove_collaborator(repo_name, username)
      # not sure if we need the accept header
      client.remove_collaborator \
        repo_name,
        username,
        accept: "application/vnd.github.ironman-preview+json"
    end

    private

    def create_status(repo:, sha:, state:, description:, target_url: nil)
      client.create_status \
        repo, sha, state,
        context: "GitDoer",
        description: description,
        target_url: target_url
    end
  end
end
