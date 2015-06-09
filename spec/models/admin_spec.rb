require 'rails_helper'

describe Admin do

  it 'name, nickname, password, email有值，且email格式正确，email, name不重复时有效' do
    Admin.create(
      name: 'foobar',
      nickname: 'foobar',
      password: 'password',
      email: 'foobar@foobar.com'
    )
    admin = Admin.new(
      name: 'foobar2',
      nickname: 'foobar',
      password: 'password',
      email: 'foobar2@foobar.com'
    )
    admin.valid?
    expect(admin).to be_valid
  end

  it 'name为空值时无效' do
    admin = Admin.new(name: nil)
    admin.valid?
    expect(admin.errors[:name]).to include("can't be blank")
  end

  it 'nickname为空值时无效' do
    admin = Admin.new(nickname: nil)
    admin.valid?
    expect(admin.errors[:nickname]).to include("can't be blank")
  end

  it 'name重复时无效' do
    Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar'
    )
    admin = Admin.new(name: 'foobar')
    admin.valid?
    expect(admin.errors[:name]).to include('has already been taken')
  end

  it 'email格式不正确时无效' do
    admin = Admin.new(email: 'foobar')
    admin.valid?
    expect(admin.errors[:email]).to include('is invalid')
  end

  it 'email为空值时不做格式验证' do
    admin = Admin.new
    admin.valid?
    expect(admin.errors.keys).not_to include(:email)
  end

  it 'email重复时无效' do
    Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
      email: 'foobar@foobar.com'
    )
    admin = Admin.new(email: 'foobar@foobar.com')
    admin.valid?
    expect(admin.errors[:email]).to include('has already been taken')
  end

  it 'email验证唯一性时不区分大小写' do
    Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
      email: 'foobar@foobar.com'
    )
    admin = Admin.new(email: 'Foobar@foobar.com')
    admin.valid?
    expect(admin.errors[:email]).to include('has already been taken')
  end

  it '保存前会将email字符全部置为小写' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
      email: 'Foobar@foobar.com'
    )
    expect(admin.email).to eq 'foobar@foobar.com'
  end

  it '默认情况下remember_digest为空值' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
    )
    expect(admin.remember_digest).to be_nil
  end

  it 'remember方法会生成remember_digest' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
    )
    admin.remember
    expect(admin.remember_digest).not_to be_nil
  end

  it 'authenticated?方法在remember_token正确的情况下返回true' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
    )
    admin.remember
    remember_token = admin.remember_token
    expect(admin.authenticated?(remember_token)).to be_truthy
  end

  it 'authenticated?方法在remember_token不正确的情况下返回false' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
    )
    admin.remember
    expect(admin.authenticated?(nil)).to be_falsey
  end

  it 'forget方法会清空remember_digest' do
    admin = Admin.create(
      name: 'foobar',
      password: 'password',
      nickname: 'foobar',
    )
    admin.remember
    admin.forget
    expect(admin.remember_digest).to be_nil
  end

end