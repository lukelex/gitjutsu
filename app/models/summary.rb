class Summary
  def initialize(files_and_todos)
    @files_and_todos = files_and_todos
  end

  def to_s
    additions = todos.select(&:addition?).count
    removals = todos.select(&:removal?).count

    return "Nothing changed" if additions.zero? && removals.zero?

    "#{additions} added & #{removals} removed TODOs"
  end

  private

  def todos
    @_todos = @files_and_todos
      .flat_map { |_file, todos| todos }
  end
end
