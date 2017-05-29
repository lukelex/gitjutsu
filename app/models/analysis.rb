class Analysis < ApplicationRecord
  belongs_to :repository

  validates :payload, presence: true
  validates_with EventValidator

  after_create_commit :enqueue_job

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
        summary = Summarize.new(result)
        pull_request.set_status(:success, summary.to_s)
      end
    end
  rescue => e
    pull_request.set_status(:error, ERROR) if live
    raise
  end

  def changed_files
    return pull_request.files if pull_request?

    repository
      .compare(payload.fetch("before"), payload.fetch("after"))
      .files
  end

  def extract_todos(file)
    PARSERS
      .find { |parser| parser.instance.able?(file.filename) }
      .instance.extract(file.patch)
  end

  def pull_request
    @_pull_request ||= repository.pull_request \
      number: payload.fetch("number"),
      sha: payload.dig("head", "sha")
  end
end
