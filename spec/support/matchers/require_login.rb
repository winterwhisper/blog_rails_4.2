RSpec::Matchers.define :require_login do |expected|
  match do |actual|
    expect(actual).to redirect_to Rails.application.routes.url_helpers.admin_login_url
  end

  failure_message do |actual|
    '访问该方法需要登录'
  end

  failure_message_when_negated do |actual|
    '访问该方法不需要登录'
  end

  description do
    '跳转到登录页面'
  end
end