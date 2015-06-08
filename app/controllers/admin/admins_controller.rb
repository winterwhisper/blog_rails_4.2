class Admin::AdminsController < Admin::BaseController

  before_action :authorize_admin

  def update
    if current_admin.update_attributes(admin_params)
      flash[:success] = '用户资料修改成功'
      redirect_to admin_profile_url
    else
      flash.now[:danger] = '用户资料修改失败'
      render :edit
    end
  end

  private

    def authorize_admin
      authorize current_admin ? current_admin : Admin
    end

    def admin_params
      params.require(:admin).permit(:avatar, :nickname, :email, :avatar_cache, :remove_avatar)
    end

end
