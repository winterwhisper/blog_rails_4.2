class Admin::SessionsController < Admin::BaseController

  layout 'admin_login'

  before_action :authorize_session

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def new
    @session = Admin::Session.new
  end

  def create
    @session = Admin::Session.new(session_params)
    if @session.save
      log_in @session.admin
      remember @session.admin if remember_me?
      flash[:success] = '登录成功'
      redirect_to admin_root_url
    else
      flash.now[:danger] = '登录失败'
      render :new
    end
  end

  def destroy
    log_out current_admin
    flash[:success] = '退出成功'
    redirect_to admin_login_url
  end

  private

    def session_params
      params.require(:session).permit(:name, :password)
    end

    def authorize_session
      authorize(:session, "#{action_name}?".to_sym)
    end

    def user_not_authorized(exception)
      redirect_to request.referrer || action_name == 'destroy' ? admin_login_url : admin_root_url
    end

end