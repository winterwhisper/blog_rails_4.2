require 'rails_helper'

feature '后台通过标签过滤文章' do

  background do
    admin_sign_in create(:admin)
  end

  scenario '点击左侧边栏的标签列出对应文章' do
    post = create(:post_with_valid_pending_tags)
    tag = post.tags.first
    visit admin_root_path
    expect(page).to have_content tag[:value]
    click_link tag[:value]
    expect(current_path).to eq admin_posts_path
    expect(page).to have_content post[:title]
  end

end
