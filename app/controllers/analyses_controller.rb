class AnalysesController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :verify_authenticity_token

  # TODO: validate that request comes from github

  def create
    repository.analyses.create \
      event: event,
      payload: event_params

    head :created
  end

  private

  def event_params
    case event
    when "push"
      params.except "sender", "pusher", "repository"
    when "pull_request"
      params.require :pull_request
    end
  end

  def event
    request.headers["X-GitHub-Event"]
  end

  def repository
    Repository.first
    # Repository.find_by(hook_id: params[:hook_id])
  end
end
