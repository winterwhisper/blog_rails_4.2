class Admin::DashboardController < Admin::BaseController

  layout 'admin_dashboard'

  before_action :authorize_dashboard

  def home
    @posts_count = Post.count
    @tags_count = Tag.count
    @comments_count = Comment.count
    @users_count = User.count
  end

  private

    def authorize_dashboard
      authorize(:dashboard, "#{action_name}?".to_sym)
    end

end
