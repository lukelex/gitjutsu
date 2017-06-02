class NewIssue
  include Renderable

  def initialize(repo, file, todo)
    @repo, @file, @todo = repo, file, todo
  end

  delegate :title, to: :@todo

  def body
    render "issues/body.md.erb"
  end

  private

  # TODO: consider using the repo's target branch
  # Check payload=>repository
  def v_path_to_file_on_github
    "https://github.com/#{@repo.name}/blob/master/#{@file}#L#{@todo.line_number}"
  end
end
