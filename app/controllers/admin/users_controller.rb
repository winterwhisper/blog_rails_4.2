class Admin::UsersController < Admin::BaseController

  def index
    @users = policy_scope(User).page(params[:page])
  end

end
