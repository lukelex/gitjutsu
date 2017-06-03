class NewIssue
  include Renderable

  def initialize(repo, file, todo)
    @repo, @file, @todo = repo, file, todo
  end

  delegate :title, to: :@todo

  def body
    render "issues/body.md.erb", vars: {
      repo: @repo, file: @file, todo: @todo,
      path_to_file_on_github: path_to_file_on_github
    }
  end

  private

  # TODO: consider using the repo's target branch
  # Check payload=>repository
  def path_to_file_on_github
    "https://github.com/#{@repo.name}/blob/master/#{@file}#L#{@todo.line_number}"
  end
end
