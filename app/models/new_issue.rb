class NewIssue
  def initialize(repo, file, todo)
    @repo, @file, @todo = repo, file, todo
  end

  delegate :title, to: :@todo

  def body
    <<~BODY
      [#{@file}:#{@todo.line_number}](#{path_to_file})

      Description:
      #{@todo.body}
    BODY
  end

  private

  # TODO: consider using the repo's target branch
  # Check payloads=>repository
  def path_to_file
    "https://github.com/#{@repo.name}/blob/master/#{@file}#L#{@todo.line_number}"
  end
end
