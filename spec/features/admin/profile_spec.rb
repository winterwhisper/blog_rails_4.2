require 'rails_helper'

feature '后台用户资料管理', js: true, driver: :selenium do

  given(:admin) { create(:admin) }

  background do
    admin_sign_in admin
  end

  scenario '通过右上角菜单点击用户资料会列出当前管理员的信息' do
    visit admin_root_path
    find(:css, 'ul.nav li.dropdown a').click
    click_link '用户资料'
    expect(current_path).to eq admin_profile_path
    expect(page).to have_content admin.name
  end

  context '编辑用户资料' do
    scenario '填写的值正确时会保存且跳转到用户资料页面' do
      edit_admin_profile_action('foobar')
      admin.reload
      expect(admin.nickname).to eq 'foobar'
      expect(current_path).to eq admin_profile_path
      within 'div.alert-success' do
        expect(page).to have_content '用户资料修改成功'
      end
    end

    scenario '填写的值正确时不会保存' do
      edit_admin_profile_action(nil)
      admin.reload
      expect(admin.nickname).to_not be_nil
      expect(admin.nickname).to eq admin.nickname
      within 'div.alert-danger' do
        expect(page).to have_content '用户资料修改失败'
      end
    end
  end

  def edit_admin_profile_action(nickname)
    visit admin_root_path
    find(:css, 'ul.nav li.dropdown a').click
    click_link '用户资料'
    click_link '修改'
    fill_in '昵称', with: nickname
    click_button '提交'
  end

end