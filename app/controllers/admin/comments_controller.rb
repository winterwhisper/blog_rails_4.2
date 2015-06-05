class Admin::CommentsController < Admin::BaseController

  def index
    @comments = Comment.order('id DESC').page(params[:page])
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = '评论删除成功'
    redirect_to admin_comments_url
  end

end
