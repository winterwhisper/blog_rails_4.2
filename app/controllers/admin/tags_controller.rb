class Admin::TagsController < Admin::BaseController

  before_action :set_tag, except: :index
  before_action :authorize_tag, except: :index

  def index
    @tags = policy_scope(Tag).page(params[:page])
  end

  def create
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
      if params[:id]
        @tag = Tag.find(params[:id])
      else
        @tag = params[:tag] ? Tag.new(tag_params) : Tag.new
      end
    end

    def tag_params
      params.require(:tag).permit(:value)
    end

end
