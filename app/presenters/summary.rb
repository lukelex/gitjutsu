class Summary
  def initialize(files_and_todos)
    @files_and_todos = files_and_todos
  end

  def to_s
    additions = todos.select(&:addition?).count
    removals = todos.select(&:removal?).count

    return "Nothing to do" if additions.zero? && removals.zero?

    [].tap { |summary|
      summary.push("#{additions} added") if additions > 0
      summary.push("#{removals} removed") if removals > 0
    }.to_sentence + " TODO's"
  end

  private

  def todos
    @_todos = @files_and_todos
      .flat_map { |_file, todos| todos }
  end
end
