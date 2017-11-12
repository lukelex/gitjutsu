# frozen_string_literal: true

require "parsers/all"

class Analysis < ApplicationRecord
  belongs_to :repository

  validates :payload, presence: true
  validates_with EventValidator

  after_create_commit :enqueue_job

  PENDING = "Analyzing..."
  ERROR   = "Errored"

  def start(live: false)
    analyzing(live) do
      changed_files.map do |file|
        [file.filename, extract_todos(file)]
      end
    end
  end

  Github::Hooks::EVENTS.each do |name|
    define_method("#{name}?") { event == name }
  end

  private

  def enqueue_job
    AnalysisJob.perform_later id
  end

  def analyzing(live)
    pull_request.set_status(:pending, PENDING) if live
    yield.tap do |result|
      if update(finished_at: Time.zone.now) && live
        summary = Summary.new(result)
        pull_request.set_status(:success, summary.to_s)
      end
    end
  rescue
    pull_request.set_status(:error, ERROR) if live
    raise
  end

  def changed_files
    return pull_request.production_files if pull_request?

    repository.compare_files \
      payload.fetch("before"),
      payload.fetch("after")
  end

  def extract_todos(file)
    Parsers::All.extract_from file
  end

  def pull_request
    @_pull_request ||= repository.pull_request \
      number: payload.fetch("number"),
      sha: payload.dig("head", "sha")
  end
end
