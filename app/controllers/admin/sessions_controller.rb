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
      flash[:success] = '登录成功'
      redirect_to admin_posts_url
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

end