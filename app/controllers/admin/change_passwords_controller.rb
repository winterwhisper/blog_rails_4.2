class Admin::ChangePasswordsController < Admin::BaseController

  before_action :set_change_password

  def new
    @change_password = Admin::ChangePassword.new
    authorize :change_password, :new?
  end

  private

  def set_change_password
    @change_password = Admin::ChangePassword.new(
      params[:change_password] ? params[:change_password] : {})
  end

end