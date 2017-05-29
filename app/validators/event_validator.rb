class EventValidator < ActiveModel::Validator
  def validate(target)
    proper_type? target
  end

  private

  def proper_type?(target)
    return if Github::Hooks::EVENTS.include?(target.event)

    target.errors.add :event, :inclusion
  end
end
