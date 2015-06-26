require 'rails_helper'

describe Admin::DashboardController do
  describe '未登录前' do
    after { expect(response).to require_login }

    describe 'GET #home' do
      it '需要登录' do
        get :home
      end
    end
  end

  describe '登录后' do
    before { log_in create(:admin) }

    describe 'GET #home' do
      it '获得对应posts/tags/comments/users数量' do
        posts = []; tags = []; comments = []
        rand(1..10).times { posts << create(:post) }
        rand(1..10).times { tags << create(:tag) }
        rand(1..10).times { comments << create(:comment) }

        get :home
        expect(assigns[:posts_count]).to eq posts.size
        expect(assigns[:tags_count]).to eq tags.size
        expect(assigns[:comments_count]).to eq comments.size
      end
    end
  end
end