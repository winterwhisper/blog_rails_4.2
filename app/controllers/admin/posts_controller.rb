class Admin::PostsController < Admin::BaseController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
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

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to admin_posts_url, notice: '文章更新成功'
    else
      flash.now[:alert] = '文章更新失败'
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_url, notice: '文章删除成功'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
