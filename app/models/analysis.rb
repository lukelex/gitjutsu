class Analysis < ApplicationRecord
  belongs_to :repository

  validates :payload, presence: true
  validates_with EventValidator

  after_create :enqueue_job

  PENDING = "Analyzing...".freeze
  ERROR   = "Errored".freeze
  PARSERS = [
    ::Parsers::Ruby,
    ::Parsers::Javascript,
    ::Parsers::Unidentified
  ].freeze

  def start(live: false)
    analyzing(live) do
      changed_files.map do |file|
        [file.filename, extract_todos(file.patch)]
      end
    end
  end

  private

  def enqueue_job
    AnalysisJob.perform_later(id: id)
  end

  def analyzing(live)
    pull_request.set_status(:pending, PENDING) if live
    yield.tap do |files|
      if live && update(finished_at: Time.zone.now)
        pull_request.set_status(:success, summarize(files.flatten))
      end
    end
  rescue => e
    pull_request.set_status(:error, ERROR) if live
    raise
  end

  def changed_files
    return pull_request.files if pull_request?

    repository
      .compare(payload.fetch("after"), payload.fetch("before"))
      .files
  end

  def extract_todos(patch)
    PARSERS
      .find { |parser| parser.instance.able?(patch) }
      .instance.extract(patch)
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
