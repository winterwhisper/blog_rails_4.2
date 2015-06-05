class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = policy_scope(Post).page(params[:page])
    filter_posts_by_tag if params[:tag].present?
  end

  def new
    @post = Post.new
    authorize @post
    set_post_tag
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = '文章创建成功'
      redirect_to admin_posts_url
    else
      flash.now[:danger] = '文章创建失败'
      set_post_tag
      render :new
    end
  end

  def edit
    set_post_tag
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = '文章更新成功'
      redirect_to admin_posts_url
    else
      flash.now[:danger] = '文章更新失败'
      set_post_tag
      render :edit
    end
  end

  def destroy
    post.destroy
    flash[:success] = '文章删除成功'
    redirect_to admin_posts_url
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def set_post_tag
      if @post.new_record?
        init_tag
      else
        tags = @post.tags
        if tags
          @tag = Tag.new(value: tags.pluck(:value).join(Tag::SPLIT_STR))
        else
          init_tag
        end
      end
    end

    def post_params
      params.require(:post).permit(:title, :body, tags_attributes: [:value])
    end

    def filter_posts_by_tag
      @posts = @posts.joins(:tags).where('tags.value = ?', params[:tag])
    end

    def init_tag
      @tag = @post.tags.new
    end

end
