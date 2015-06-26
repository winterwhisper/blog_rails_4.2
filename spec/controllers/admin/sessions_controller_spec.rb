require 'rails_helper'

describe Admin::SessionsController do
  describe '未登录前' do

    describe 'GET #index' do
      before { get :new }
      it { should render_template :new }
    end

    describe 'POST #create' do
      let(:admin) { create(:admin) }

      context '登录信息正确时' do
        context '选择记住我时' do
          before do
            post :create, session: {
              name: admin.name,
              password: admin.password,
              remember_me: Admin::Session::REMEMBER_ME
            }
          end

          it '在cookies中记录相关信息' do
            expect(cookies.signed[:admin_id]).to eq admin.id
          end

          it { should redirect_to admin_root_url }
        end

        context '未选择记住我时' do
          before do
            post :create, session: {
              name: admin.name,
              password: admin.password
            }
          end

          it '在session中记录相关信息' do
            expect(session[:admin_id]).to eq admin.id
          end

          it { should redirect_to admin_root_url }
        end
      end

      context '登录信息不正确时' do
        before do
          post :create, session: {
            name: admin.name,
            password: 'password',
            remember_me: Admin::Session::REMEMBER_ME
          }
        end

        it '在session中未记录相关信息' do
          expect(session[:admin_id]).to be_nil
        end

        it '在cookies中未记录相关信息' do
          expect(cookies[:admin_id]).to be_nil
        end

        it { should render_template :new }
      end
    end

    describe 'delete #destroy' do
      it '需要登录' do
        delete :destroy
        expect(response).to require_login
      end
    end
  end

  describe '登录后' do
    before { log_in create(:admin) }

    describe 'GET #new' do
      before { get :new }
      it { should redirect_to admin_root_url }
    end

    describe 'POST #create' do
      before { post :create }
      it { should redirect_to admin_root_url }
    end

    describe 'DELETE #destroy' do
      before { delete :destroy }

      it '清空session' do
        expect(session[:admin_id]).to be_nil
      end

      it '清空cookies' do
        expect(cookies[:admin_id]).to be_nil
        expect(cookies[:remember_token]).to be_nil
      end

      it { should redirect_to admin_login_url }
    end
  end
end