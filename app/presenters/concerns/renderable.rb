module Renderable
  private

  def render(view_file)
    ApplicationController.render \
      inline: contents_of(view_file),
      assigns: everything,
      layout: false
  end

  def everything
    vs = instance_variables
      .map { |name| [name.to_s.delete("@"), instance_variable_get(name)] }
      .to_h

    ms = methods.grep(/^v_/)
      .map { |name| [name.gsub(/^v_/), send(name)]}
      .to_h

    vs.merge ms
  end

  def contents_of(name)
    File.read(File.join(__dir__, "../../views", name))
  end
end
