require 'rails_helper'

describe Admin::ChangePasswordsController do
  describe '未登录前' do
    after { expect(response).to require_login }
    describe 'GET #new' do
      it '需要登录' do
        get :new
      end
    end

    describe 'POST #create' do
      it '需要登录' do
        post :create
      end
    end
  end

  describe '登录后' do
    let(:admin) { create(:admin) }

    before { log_in admin }

    describe 'GET #new' do
      before { get :new }
      it { should render_template :new }
    end

    describe 'POST #create' do
      context '所传属性值不正确时' do
        before do
          post :create, change_password: {
                        old_password: admin.password,
                        password: 'password',
                        password_confirmation: 'password1'
                      }
        end

        it '密码不会修改' do
          admin.reload
          expect(admin.authenticate(admin.password)).to eq admin
          expect(admin.authenticate('password')).to be_falsey
        end

        it { should render_template :new }
      end

      context '所传属性值正确时' do
        before do
          post :create, change_password: {
                        old_password: admin.password,
                        password: 'password',
                        password_confirmation: 'password'
                      }
        end

        it '密码修改为指定值' do
          admin.reload
          expect(admin.authenticate('password')).to eq admin
        end

        it { should redirect_to new_admin_change_passwords_url }
      end
    end
  end
end