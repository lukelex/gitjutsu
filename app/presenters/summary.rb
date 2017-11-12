# frozen_string_literal: true

class Summary
  def initialize(files_and_todos)
    @files_and_todos = files_and_todos
  end

  def to_s
    additions = todos.select(&:addition?).count
    removals = todos.select(&:removal?).count

    return "Nothing to do" if additions.zero? && removals.zero?

    change_summary additions, removals
  end

  private

  def change_summary(additions, removals)
    [].tap do |summary|
      summary.push("#{additions} added") if additions.positive?
      summary.push("#{removals} removed") if removals.positive?
    end.to_sentence + " TODO's"
  end

  def todos
    @_todos = @files_and_todos
      .flat_map { |_file, todos| todos }
  end
end
