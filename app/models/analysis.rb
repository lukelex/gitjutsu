class Analysis < ApplicationRecord
  belongs_to :repository

  validates :payload, presence: true
  validates_with EventValidator

  after_commit :enqueue_job

  PENDING = "Analyzing...".freeze
  ERROR   = "Errored".freeze

  def start(live: false)
    analyzing(live) do
      pull_request.files.map do |file|
        ::Parsers::Ruby.instance.extract file.patch
      end
    end
  end

  private

  def enqueue_job
    # AnalysisJob.create(id: anal.id)
  end

  def analyzing(live)
    pull_request.set_status(:pending, PENDING) if live
    yield.tap do |files|
      if live && update(finished_at: Time.zone.now)
        pull_request.set_status(:success, summarize(files.flatten))
      end
    end
  rescue
    pull_request.set_status(:error, ERROR) if live
    raise
  end

  def pull_request
    @_pull_request ||= repository.pull_request \
      number: payload.fetch("number"),
      sha: payload.dig("head", "sha")
  end

  def summarize(todos)
    "#{todos.select(&:addition?).count} added & #{todos.select(&:removal?).count} removed TODOs"
  end
end
