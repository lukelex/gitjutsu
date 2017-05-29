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
    existing_issues = repository.issues.select do |i|
      i.labels.any? { |l| l.name.include?("todos") }
    end

    files_and_todos.each do |filename, todos|
      todos.each do |todo|
        if todo.addition?
          issue = NewIssue.new(repository, filename, todo)
          repository.create_issue(issue.title, issue.body)
        elsif todo.removal?
          issue = find_issue(existing_issues, filename, todo) || next
          repository.close_issue(issue.number)
        end
      end
    end
  end

  def find_issue(issues, filename, todo)
    issues.find do |issue|
      unique_id = METADATA.match(issue.body)
      unique_id.to_s == todo.unique_id(filename: filename)
    end
  end

  METADATA = /(?<=\[\/{2}\]:\s\#\s\(gitdoer-metadata:\s)[^\)]+/i
end
