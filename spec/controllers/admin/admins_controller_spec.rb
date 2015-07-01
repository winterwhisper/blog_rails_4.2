require 'rails_helper'

describe Admin::AdminsController do
  describe '未登录前' do
    let(:admin) { create(:admin) }

    after { expect(response).to require_login }

    describe 'GET #show' do
      it '需要登录' do
        get :show, id: admin
      end
    end

    describe 'GET #edit' do
      it '需要登录' do
        get :edit, id: admin
      end
    end

    describe 'PATCH #update' do
      it '需要登录' do
        get :edit, id: admin, admin: attributes_for(:admin)
      end
    end
  end

  describe '登录后' do
    let(:admin) { create(:admin) }

    before do
      log_in admin
    end

    describe 'GET #show' do
      before { get :show, id: admin }

      it { should render_template :show }
    end

    describe 'GET #edit' do
      before { get :edit, id: admin }

      it { should render_template :edit }
    end

    describe 'PATCH #update' do
      context '所传属性值不正确时' do
        before { patch :update, id: admin, admin: attributes_for(:admin, nickname: nil) }

        it '数据不会变化' do
          current_admin.reload
          expect(current_admin.nickname).to_not be_nil
        end

        it { should render_template :edit }
      end

      context '所传属性值正确时' do
        before { patch :update, id: admin, admin: attributes_for(:admin, nickname: 'foobar') }

        it '指定字段的值会变化' do
          current_admin.reload
          expect(current_admin.nickname).to eq 'foobar'
        end

        it { should redirect_to admin_profile_url }
      end
    end

  end
end