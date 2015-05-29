class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order('id DESC').page(params[:page])
    filter_posts_by_tag if params[:tag].present?
  end

  def new
    @post = Post.new
    @tag = @post.tags.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to admin_posts_url, notice: '文章创建成功'
    else
      flash.now[:alert] = '文章创建失败'
      render :new
    end
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to admin_posts_url, notice: '文章更新成功'
    else
      flash.now[:alert] = '文章更新失败'
      render :edit
    end
  end

  def destroy
    post.destroy
    redirect_to admin_posts_url, notice: '文章删除成功'
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, tags_attributes: [:value])
    end

    def filter_posts_by_tag
      @posts = @posts.joins(:tags).where('tags.value = ?', params[:tag])
    end

end
