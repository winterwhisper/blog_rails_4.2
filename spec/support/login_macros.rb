module LoginMacros
  def admin_sign_in(user)
    visit admin_login_path
    fill_in 'session[name]', with: user.name
    fill_in 'session[password]', with: user.password
    click_button '登录'
  end
end