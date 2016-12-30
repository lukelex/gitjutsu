class AnalysesController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :verify_authenticity_token

  # TODO: validate that request comes from github

  def create
    require 'pry'; binding.pry

    repository.analyses
      .create(payload: pull_request_params)
      .start(live: true)
    # AnalysisJob.create(id: anal.id)

    render nothing: true, status: :created
  end

  private

  def pull_request_params
    params.require :pull_request
  end

  def repository
    Repository.first
    # Repository.find_by(hook_id: params[:hook_id])
  end
end
