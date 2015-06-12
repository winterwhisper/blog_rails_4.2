require 'rails_helper'

describe Admin::PostsController do
  before do
    log_in create(:admin)
  end

  describe 'GET #index' do
    context '存在params[:tag]时' do
      it '返回属于指定tag的文章的数组' do
        post1 = create(:post)
        post2 = create(:post, pending_tags: 'foobar tag')
        get :index, tag: 'foobar tag'
        expect(assigns(:posts)).to eq [post2]
      end
      it '渲染 :index 模板' do
        get :index, tag: 'foobar tag'
        expect(response).to render_template :index
      end
    end
    context '不存在params[:tag]时' do
      it '返回按id倒序排列所有文章的数组' do
        post1 = create(:post)
        post2 = create(:post)
        get :index
        expect(assigns(:posts)).to eq [post2, post1]
      end
      it '渲染 :index 模板' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    it '新建一个@post' do

    end
  end
end

