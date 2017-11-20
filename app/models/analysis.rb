# frozen_string_literal: true

require "parsers/all"

class Analysis < ApplicationRecord
  belongs_to :repository

  validates :payload, presence: true
  validates_with EventValidator

  after_create_commit :enqueue_job

  def start(live: false)
    pull_request
      .analyzing(live, &method(:extract_todos))
      .tap { update(finished_at: Time.zone.now) }
  end

  Github::Hooks::EVENTS.each do |name|
    define_method("#{name}?") { event == name }
  end

  private

  def extract_todos
    changed_files.map do |f|
      [f.filename, Parsers::All.extract_from(f)]
    end
  end

  def enqueue_job
    AnalysisJob.perform_later id
  end

  def changed_files
    return pull_request.production_files if pull_request?

    repository.compare_files \
      payload.fetch("before"),
      payload.fetch("after")
  end

  def pull_request
    @_pull_request ||= repository.pull_request \
      number: payload.fetch("number"),
      sha: payload.dig("head", "sha")
  end
end
