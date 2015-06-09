class Admin::PostsController < Admin::BaseController

  before_action :set_post, except: :index
  before_action :authorize_post, except: :index
  before_action :set_post_tag, only: [:new, :edit]

  def index
    @posts = policy_scope(Post).page(params[:page])
    filter_posts_by_tag if params[:tag].present?
  end

  def create
    if @post.save
      flash[:success] = '文章创建成功'
      redirect_to admin_posts_url
    else
      flash.now[:danger] = '文章创建失败'
      set_post_tag
      render :new
    end
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
    @post.destroy
    flash[:success] = '文章删除成功'
    redirect_to admin_posts_url
  end

  private

    def set_post
      if params[:id]
        @post = Post.find(params[:id])
      else
        @post = params[:post] ? Post.new(post_params) : Post.new
      end
    end

    def authorize_post
      authorize @post
    end

    def set_post_tag
      unless @post.new_record?
        tags = @post.tags
        @tag = tags.pluck(:value).join(Tag::SPLIT_STR) if tags
      end
    end

    def post_params
      params.require(:post).permit(:title, :body, :pending_tags)
    end

    def filter_posts_by_tag
      @posts = @posts.joins(:tags).where('tags.value = ?', params[:tag])
    end

end
