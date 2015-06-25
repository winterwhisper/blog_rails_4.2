require 'rails_helper'

describe Admin::TagsController do
  before do
    log_in create(:admin)
  end

  describe 'GET #index' do
    let(:tag1) { create(:tag) }

    it '返回按id顺序排列所有标签的数组' do
      tag1
      tag2 = create(:tag)
      get :index
      expect(assigns(:tags)).to eq [tag1, tag2]
    end
    it '渲染 :index 模板' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it '新建一个Tag实例并分配给@tag' do
      get :new
      expect(assigns(:tag)).to be_a_new(Tag)
    end

    it '渲染 :new 模板' do
      get :new
      expect(assigns(response)).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:tag) { create(:tag) }
    it '按照传入的id取出对应的Tag实例并分配给@tag' do
      get :edit, id: tag
      expect(assigns(:tag)).to eq tag
    end

    it '渲染 :edit 模板' do
      get :edit, id: tag
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context '所传属性值正确时' do
      it '创建对应tag实例并存入数据库' do
        expect {
          post :create, tag: attributes_for(:tag)
        }.to change(Tag, :count).by(1)
      end

      it '重定向到#index' do
        post :create, tag: attributes_for(:tag)
        expect(response).to redirect_to admin_tags_url
      end
    end

    context '所传属性值不正确时' do
      it '没有创建对应tag实例，数据库数据不变' do
        expect {
          post :create, tag: attributes_for(:tag, value: nil)
        }.to_not change(Tag, :count)
      end

      it '重新渲染 :new 模板' do
        post :create, tag: attributes_for(:tag, value: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:tag) { create(:tag, value: 'patch test value') }
    context '所传属性值正确时' do
      it '更新指定tag实例' do
        patch :update, id: tag, tag: attributes_for(:tag)
        expect(assigns(:tag)).to eq(tag)
      end

      it '更新实例指定的字段值' do
        patch :update, id: tag, tag: attributes_for(:tag)
        tag.reload
        expect(tag.value).to eq(attributes_for(:tag)[:value])
      end

      it '重定向到#index' do
        patch :update, id: tag, tag: attributes_for(:tag)
        expect(response).to redirect_to admin_tags_url
      end
    end

    context '所传属性值不正确时' do
      it '没有修改指定tag实例的值' do
        patch :update, id: tag,
              tag: attributes_for(:tag, value: nil)
        tag.reload
        expect(tag.value).to_not be_nil
      end

      it '重新渲染 :edit 模板' do
        patch :update, id: tag,
              tag: attributes_for(:tag, value: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:tag) { create(:tag) }

    it '删除对应tag' do
      tag
      expect {
        delete :destroy, id: tag
      }.to change(Tag, :count).by(-1)
    end

    it '重定向到#index' do
      delete :destroy, id: tag
      expect(response).to redirect_to admin_tags_url
    end
  end
end
