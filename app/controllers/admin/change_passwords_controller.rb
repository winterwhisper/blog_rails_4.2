class Admin::ChangePasswordsController < Admin::BaseController

  before_action :set_change_password
  before_action :authorize_change_password

  def create
    if @change_password.save
      flash[:success] = '密码修改成功'
      redirect_to new_admin_change_passwords_url
    else
      flash.now[:danger] = '密码修改失败'
      render :new
    end
  end

  private

    def set_change_password
      @change_password = Admin::ChangePassword.new(current_admin,
        params[:change_password] ? change_password_params : {})
    end

    def authorize_change_password
      authorize(:change_password, "#{action_name}?".to_sym)
    end

    def change_password_params
      params.require(:change_password).permit(:old_password, :password, :password_confirmation)
    end

end