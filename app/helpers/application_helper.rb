module ApplicationHelper
  def page_active?(controller_action)
    controller_action = controller_action.split("#")
    controller = controller_action[0]
    action = controller_action[1]

    if controller == params[:controller] and (!action or (action and action == params[:action]))
      'active'
    else
      ''
    end
  end

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end
end
