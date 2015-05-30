class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order('id DESC').page(params[:page])
    filter_posts_by_tag if params[:tag].present?
  end

  def new
    @post = Post.new
    set_post_tag
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
    set_post_tag
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
