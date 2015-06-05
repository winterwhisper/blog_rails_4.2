module SessionsHelper

  # current_user / current_admin
  %w(user admin).each do |obj|
    define_method "current_#{obj}" do
      # 相当于 @current_user ||= User.find_by(id: session[:id])
      if instance_variable_get("@current_#{obj}")
        instance_variable_get("@current_#{obj}")
      else
        instance_variable_set("@current_#{obj}", authenticate_by_session_or_cookies(obj))
      end
    end
  end

  def log_in(user)
    session[session_key(user)] = user.id
  end

  def log_out(user)
    session.delete(session_key(user))
    cookies.delete(session_key(user))
    cookies.delete(:remember_token)
    user.forget
  end

  def remember_me?
    params[:session][:remember_me] == Admin::Session::REMEMBER_ME
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[session_key(user)] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def session_key(obj)
    if obj.is_a?(String)
      "#{obj}_id".to_sym
    else
      "#{obj.class.to_s.underscore}_id".to_sym
    end
  end

  def authenticate_by_session_or_cookies(user)
    if session[session_key(user)]
      authenticate_by_session(user)
    elsif cookies[:remember_token]
      authenticate_by_cookies(user)
    end
  end

  def authenticate_by_session(user)
    obj_klass_find_by_id(user, session[session_key(user)])
  end

  def authenticate_by_cookies(user)
    _user = obj_klass_find_by_id(user, cookies.signed[session_key(user)])
    if _user and _user.authenticated?(cookies.signed[:remember_token])
      log_in(_user)
      _user
    end
  end

  def obj_klass(obj)
    obj.classify.safe_constantize
  end

  def obj_klass_find_by_id(user, id)
    obj_klass(user).find_by(id: id)
  end

end