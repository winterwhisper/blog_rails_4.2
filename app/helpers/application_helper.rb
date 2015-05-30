module ApplicationHelper

  def time_formater(time)
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

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

end
