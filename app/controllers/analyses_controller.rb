class AnalysesController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :verify_authenticity_token
  before_action :verify_github_authenticity

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

  def repository
    Repository.first
    # Repository.find_by(hook_id: params[:hook_id])
  end

  delegate :secure_compare, to: Rack::Utils
  def verify_github_authenticity
    head(401) unless secure_compare(payload_signature, github_signature)
  end

  def payload_signature
    "sha1=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), ENV["SECRET_TOKEN"], request.body.read)
  end

  def event
    request.headers["X-GitHub-Event"]
  end

  def github_signature
    request.env["HTTP_X_HUB_SIGNATURE"]
  end
end
