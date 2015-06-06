class Admin::BaseController < ApplicationController

  include Pundit

  layout 'admin'

  before_action :set_tags
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    def set_tags
      @tags = Tag.all
    end

    def pundit_user
      current_admin
    end

    def user_not_authorized(exception)
      flash[:warning] = exception.message
      redirect_to request.referrer || admin_login_url
    end

end