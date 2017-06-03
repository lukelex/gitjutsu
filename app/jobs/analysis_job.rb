class AnalysisJob < ApplicationJob
  queue_as :default

  def perform(analysis_id)
    analysis = Analysis.find(analysis_id)

    files_and_todos = analysis.start(live: analysis.pull_request?)

    return if analysis.pull_request?

    persist_issues_on_github \
      analysis.repository,
      files_and_todos
  end

  private

  def persist_issues_on_github(repository, files_and_todos)
    files_and_todos.each do |filename, todos|
      todos.each do |todo|
        existing = find_issue(repository, filename, todo)

        # TODO: Add feature tests for adding and removing TODO's
        # It should test wether we're correctly adding or removing
        # them on both existing and non-existing scenarios
        if existing && todo.removal?
          repository.close_issue issue.number
        elsif (not existing) && todo.addition?
          issue = NewIssue.new(repository, filename, todo)
          repository.create_issue issue.title, issue.body
        end
      end
    end
  end

  def find_issue(repository, filename, todo)
    existing_issues(repository).find do |issue|
      unique_id = METADATA.match(issue.body)
      unique_id.to_s == todo.unique_id(filename: filename)
    end
  end

  def existing_issues(repository)
    @existing_issues ||= repository.issues.select do |i|
      i.labels.any? { |l| l.name.include?("todos") }
    end
  end

  METADATA = /(?<=\[\/{2}\]:\s\#\s\(gitdoer-metadata:\s)[^\)]+/i
end
