class Admin::SearchsController < Admin::BaseController

  layout 'admin_no_box'

  def show
    authorize :search, :show?
    @posts = Post.where('title like ?', "%#{params[:q]}%")
    @tags = Tag.where('value like ?', "%#{params[:q]}%")
    @comments = Comment.where('body like ?', "%#{params[:q]}%")
    # @users = User.where('title like ?', "%#{params[:q]}%")
  end

end
