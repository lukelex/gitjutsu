# frozen_string_literal: true

class NewIssue
  include Renderable

  def initialize(repo, file, todo)
    @repo = repo
    @file = file
    @todo = todo
  end

  delegate :title, to: :@todo

  def body
    render "issues/body.md.erb", vars: {
      repo: @repo, file: @file, todo: @todo,
      description: description,
      path_to_file_on_github: path_to_file_on_github
    }
  end

  private

  def description
    signs = Parsers::All.comment_signs.join("|")
    @todo.body.split("\n")
      .map { |line| "> " + line.gsub(/[+-]\s*(#{signs})/, "").strip }
      .join("\n")
  end

  # TODO: consider using the repo's target branch
  # Check payload=>repository
  def path_to_file_on_github
    "https://github.com/#{@repo.name}/blob/master/#{@file}#L#{@todo.line_number}"
  end
end
