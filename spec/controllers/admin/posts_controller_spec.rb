require 'rails_helper'

describe Admin::PostsController do
  describe '未登录前' do
    describe 'GET #index' do
      it '需要登录' do
        get :index
        expect(response).to require_login
      end
    end

    describe 'GET #new' do
      it '需要登录' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it '需要登录' do
        get :edit, id: create(:post)
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it '需要登录' do
        post :create, post: attributes_for(:post)
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
      it '需要登录' do
        patch :update, id: create(:post), post: attributes_for(:post)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it '需要登录' do
        delete :destroy, id: create(:post)
        expect(response).to require_login
      end
    end
  end

  describe '登录后' do
    before do
      log_in create(:admin)
    end

    describe 'GET #index' do
      let(:post1) { create(:post) }
      context '存在params[:tag]时' do
        it '返回属于指定tag的文章的数组' do
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
          post1
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
      it '新建一个Post实例并分配给@post' do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end

      it '渲染 :new 模板' do
        get :new
        expect(assigns(response)).to render_template :new
      end
    end

    describe 'GET #edit' do
      let(:post) { create(:post) }
      it '按照传入的id取出对应的Post实例并分配给@post' do
        get :edit, id: post
        expect(assigns(:post)).to eq post
      end

      it '渲染 :edit 模板' do
        get :edit, id: post
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context '所传属性值正确时' do
        it '创建对应post实例并存入数据库' do
          expect {
            post :create, post: attributes_for(:post)
          }.to change(Post, :count).by(1)
        end

        it '重定向到#index' do
          post :create, post: attributes_for(:post)
          expect(response).to redirect_to admin_posts_url
        end
      end

      context '所传属性值不正确时' do
        it '没有创建对应post实例，数据库数据不变' do
          expect {
            post :create, post: attributes_for(:post, title: nil)
          }.to_not change(Post, :count)
        end

        it '重新渲染 :new 模板' do
          post :create, post: attributes_for(:post, title: nil)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      let(:post) do
        create(:post,
               title: 'patch test title',
               body: 'patch test body')
      end
      context '所传属性值正确时' do
        it '更新指定post实例' do
          patch :update, id: post, post: attributes_for(:post)
          expect(assigns(:post)).to eq(post)
        end

        it '更新实例指定的字段值' do
          patch :update, id: post, post: attributes_for(:post)
          post.reload
          expect(post.title).to eq(attributes_for(:post)[:title])
          expect(post.body).to eq(attributes_for(:post)[:body])
        end

        it '重定向到#index' do
          patch :update, id: post, post: attributes_for(:post)
          expect(response).to redirect_to admin_posts_url
        end
      end

      context '所传属性值不正确时' do
        it '没有修改指定post实例的值' do
          patch :update, id: post,
                post: attributes_for(:post,
                                     title: nil)
          post.reload
          expect(post.title).to eq('patch test title')
          expect(post.body).to_not eq(attributes_for(:post)[:body])
        end

        it '重新渲染 :edit 模板' do
          patch :update, id: post,
                post: attributes_for(:post,
                                     title: nil)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:post) { create(:post) }

      it '删除对应post' do
        post
        expect {
          delete :destroy, id: post
        }.to change(Post, :count).by(-1)
      end

      it '重定向到#index' do
        delete :destroy, id: post
        expect(response).to redirect_to admin_posts_url
      end
    end
  end
end

