class Admin::DashboardController < Admin::BaseController

  def home
    authorize :dashboard, :show?
  end

end
