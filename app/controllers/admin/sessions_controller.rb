class Admin::SessionsController < Admin::BaseController

  layout 'admin_login'

  def new
    @session = Admin::Session.new
  end

  def create
    @session = Admin::Session.new(session_params)
    if @session.save
      log_in @session.admin
      remember @session.admin if remember_me?
      redirect_to admin_posts_url, notice: '登录成功'
    else
      flash.now[:alert] = '登录失败'
      render :new
    end
  end

  def destroy
    log_out current_admin
    redirect_to admin_login_url, notice: '退出成功'
  end

  private

    def session_params
      params.require(:session).permit(:name, :password)
    end

end