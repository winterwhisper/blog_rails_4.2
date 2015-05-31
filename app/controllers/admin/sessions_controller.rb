class Admin::SessionsController < Admin::BaseController

  layout 'admin_login'

  def new
    @session = Admin::Session.new
  end

end