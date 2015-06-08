class Admin::AdminsController < Admin::BaseController

  before_action :authorize_admin

  def show

  end

  private

    def authorize_admin
      authorize current_admin ? current_admin : Admin
    end

end
