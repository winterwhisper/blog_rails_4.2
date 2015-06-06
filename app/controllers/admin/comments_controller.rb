class Admin::CommentsController < Admin::BaseController

  def index
    @comments = policy_scope(Comment).page(params[:page])
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.destroy
    flash[:success] = '评论删除成功'
    redirect_to admin_comments_url
  end

end
