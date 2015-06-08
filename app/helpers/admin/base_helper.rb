module Admin::BaseHelper

  def is_obj_has_error?(obj, attr)
    obj.errors.has_key?(attr)
  end

  def render_form_error_class(obj, attr)
    'has-error' if is_obj_has_error?(obj, attr)
  end

  def render_form_error_message(obj, attr)
    if is_obj_has_error?(obj, attr)
      content_tag(:p, obj.errors[attr].first, class: 'help-block')
    end
  end

  def render_sidenav_highlight(_controller_name, _action_name = nil, *other_conditions)
    controller_actived = controller_name == _controller_name
    action_actived = action_name == _action_name
    actived = _action_name ? controller_actived && action_actived : controller_actived
    oth_actived = other_conditions.inject { |result, c| result && c } if other_conditions.present?
    fin_actived = other_conditions.present? ? (actived and oth_actived) : actived
    fin_actived ? 'active' : ''
  end

end