class Admin::TagsController < Admin::BaseController

  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.page(params[:page])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(tag_params)
    if @tag.save
      flash[:success] = '标签创建成功'
      redirect_to admin_tags_url
    else
      flash.now[:danger] = '标签创建失败'
      render :new
    end
  end

  def update
    if @tag.update_attributes(tag_params)
      flash[:success] = '标签修改成功'
      redirect_to admin_tags_url
    else
      flash.now[:danger] = '标签修改失败'
      render :edit
    end
  end

  def destroy
    @tag.destroy
    flash[:success] = '标签删除成功'
    redirect_to admin_tags_url
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:value)
    end

end
