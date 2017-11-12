# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat close_button
        concat message
      end)
    end
    nil
  end

  private

  MESSAGES = {
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-warning",
    notice: "alert-info"
  }.freeze

  def bootstrap_class_for(flash_type)
    MESSAGES[flash_type.to_sym] || flash_type.to_s
  end

  def close_button
    content_tag(:button, "x", class: "close", data: { dismiss: "alert" })
  end
end
