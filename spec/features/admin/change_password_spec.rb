require 'rails_helper'

feature '后台修改管理员密码', js: true, driver: :selenium do

  given(:admin_attrs) { attributes_for(:admin) }
  given(:admin) { create(:admin, admin_attrs) }

  background do
    admin_sign_in admin
  end

  scenario '所有字段填写正确后密码修改成功并跳转回修改页面' do
    change_password_action
    admin.reload
    expect(admin.authenticate('password')).to eq admin
    expect(current_path).to eq new_admin_change_passwords_path
    within 'div.alert-success' do
      expect(page).to have_content '密码修改成功'
    end
  end

  scenario '旧密码填写错误后显示对应错误信息且密码不会被修改' do
    change_password_action(old_password: "#{admin_attrs[:password]}error")
    admin.reload
    expect(admin.authenticate('password')).to be_falsy
    expect(admin.authenticate(admin_attrs[:password])).to eq admin
    within 'div.alert-danger' do
      expect(page).to have_content '密码修改失败'
    end
    expect(page).to have_content '旧密码输入错误'
  end

  scenario '所填表单值存在错误时密码不会被修改' do
    change_password_action(password_confirmation: 'passworderror')
    admin.reload
    expect(admin.authenticate('password')).to be_falsy
    expect(admin.authenticate(admin_attrs[:password])).to eq admin
    within 'div.alert-danger' do
      expect(page).to have_content '密码修改失败'
    end
  end

  def change_password_action(opts = {})
    opts[:old_password] ||= admin_attrs[:password]
    opts[:password] ||= 'password'
    opts[:password_confirmation] ||= opts[:password]

    visit admin_root_path
    find(:css, 'ul.nav li.dropdown a').click
    click_link '修改密码'
    fill_in 'change_password[old_password]', with: opts[:old_password]
    fill_in 'change_password[password]', with: opts[:password]
    fill_in 'change_password[password_confirmation]', with: opts[:password_confirmation]
    click_button '提交'
  end

end