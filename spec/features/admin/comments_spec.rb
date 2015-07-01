require 'rails_helper'

feature '后台评论管理' do

  given!(:comment) { create(:comment) }

  background do
    admin_sign_in create(:admin)
  end

  context '查' do
    scenario '列表页有指定评论' do
      visit admin_root_path
      click_link '评论'
      expect(page).to have_content comment[:body]
    end
  end

  context '删', js: true do
    scenario '删除评论', driver: :selenium do
      visit admin_root_path
      click_link '评论'
      expect(page).to have_content comment[:body]
      expect {
        click_link '删除'
        accept_alert('确定要删除吗？')
        sleep 1
      }.to change(Comment, :count).by(-1)
      expect(current_path).to eq admin_comments_path
      within 'div.alert-success' do
        expect(page).to have_content '评论删除成功'
      end
      expect(page).to_not have_content comment[:body]
    end
  end

end