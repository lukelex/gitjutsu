class AnalysisJob < ApplicationJob
  queue_as :default

  def perform(analysis_id)
    analysis = Analysis.find(analysis_id)
    repository = analysis.repository

    files_and_todos = analysis.start(live: analysis.pull_request?)

    return if analysis.pull_request?

    files_and_todos.each do |file, todos|
      todos.each do |todo|
        issue = NewIssue.new(repository, file, todo)
        repository.create_issue(issue.title, issue.body)
      end
    end
  end
end
