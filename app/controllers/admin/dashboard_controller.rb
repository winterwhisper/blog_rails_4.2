class Admin::DashboardController < Admin::BaseController

  before_action :authorize_dashboard

  private

    def authorize_dashboard
      authorize(:dashboard, "#{action_name}?".to_sym)
    end

end
