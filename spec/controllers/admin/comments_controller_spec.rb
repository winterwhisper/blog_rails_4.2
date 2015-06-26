require 'rails_helper'

describe Admin::CommentsController do
  describe '未登录前' do
    after { expect(response).to require_login }

    describe 'GET #index' do
      it '需要登录' do
        get :index
      end
    end

    describe 'DELETE #destroy' do
      it '需要登录' do
        comment = create(:comment)
        delete :destroy, id: comment
      end
    end
  end


  describe '登录后' do
    before do
      log_in create(:admin)
    end

    describe 'GET #index' do
      before { get :index }

      it '返回按id倒序排列的所有comments数组' do
        comment1 = create(:comment)
        comment2 = create(:comment)
        expect(assigns[:comments]).to eq [comment2, comment1]
      end

      it { should render_template :index }
    end

    describe 'DELETE #destroy' do
      let(:comment) { create(:comment) }

      it '删除对应的comment' do
        comment
        expect {
          delete :destroy, id: comment
        }.to change(Comment, :count).by(-1)
      end

      it '重定向到#index' do
        delete :destroy, id: comment
        expect(response).to redirect_to admin_comments_url
      end
    end
  end
end