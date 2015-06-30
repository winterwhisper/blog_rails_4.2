require 'rails_helper'

feature '后台文章管理', js: true do

  background do
    admin_sign_in create(:admin)
  end

  context '增' do
    scenario '用正确的值添加新文章' do
      post = attributes_for(:post_with_valid_pending_tags)
      expect { create_post_action(post) }.to change(Post, :count).by(1)
      expect(current_path).to eq admin_posts_path
      within 'div.alert-success' do
        expect(page).to have_content '文章创建成功'
      end
      expect(page).to have_content post[:title]
    end

    scenario '用不正确的值添加新文章' do
      post = attributes_for(:post_with_valid_pending_tags, title: nil)
      expect { create_post_action(post) }.to_not change(Post, :count)
      within 'div.alert-danger' do
        expect(page).to have_content '文章创建失败'
      end
    end
  end

  context '查' do
    scenario '列表页有指定文章' do
      post = create(:post)
      visit admin_root_path
      click_link '文章'
      click_link '所有文章'
      expect(page).to have_content post.title
    end
  end

  context '改' do
    given!(:post) { create(:post) }

    scenario '用正确的值修改文章' do
      edit_post_action('title')
      post.reload
      expect(post.title).to eq 'title'
      expect(current_path).to eq admin_posts_path
      within 'div.alert-success' do
        expect(page).to have_content '文章更新成功'
      end
    end

    scenario '用错误的值修改文章' do
      edit_post_action(nil)
      expect(post.title).to_not be_nil
      expect(post.title).to eq post.title
      within 'div.alert-danger' do
        expect(page).to have_content '文章更新失败'
      end
    end
  end

  context '删' do
    scenario '删除文章', driver: :selenium do
      post = create(:post)
      visit admin_root_path
      click_link '文章'
      click_link '所有文章'
      expect(page).to have_content post.title
      expect {
        click_link '删除'
        accept_alert('确定要删除吗？')
      }.to change(Post, :count).by(-1)
      expect(current_path).to eq admin_posts_path
      within 'div.alert-success' do
        expect(page).to have_content '文章删除成功'
      end
      expect(page).to_not have_content post.title
    end
  end

  def create_post_action(post)
    visit admin_root_path
    click_link '文章'
    click_link '新建文章'
    fill_in '标题', with: post[:title]
    fill_in 'post[body]', with: post[:body]
    fill_in 'tags-field_tag', with: post[:pending_tags]
    click_button '提交'
  end

  def edit_post_action(title)
    visit admin_root_path
    click_link '文章'
    click_link '所有文章'
    click_link '编辑'
    fill_in '标题', with: title
    click_button '提交'
  end

end