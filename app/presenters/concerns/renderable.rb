# frozen_string_literal: true

module Renderable
  private

  def render(view_file, vars:)
    ApplicationController.render \
      inline: contents_of(view_file),
      assigns: vars,
      layout: false
  end

  def contents_of(name)
    File.read(File.join(__dir__, "../../views", name))
  end
end
