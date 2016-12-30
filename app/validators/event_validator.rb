class EventValidator < ActiveModel::Validator
  def validate(target)
    proper_type? target
    push_to_master? target
  end

  private

  def proper_type?(target)
    return if Github::Hooks::EVENTS.include?(target.event)

    target.errors.add :event, :inclusion
  end

  def push_to_master?(target)
    return if target.event != "push"
    return if target.payload.dig("ref") == "refs/heads/master"

    target.errors.add :ref, "can't analyse other than master"
  end
end
