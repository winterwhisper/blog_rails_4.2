require 'rails_helper'

describe Admin do
  describe 'validators' do
    it 'name, nickname, password, email有值，且email格式正确，email, name不重复时有效' do
      create(:admin)
      admin = build(:admin)
      admin.valid?
      expect(admin).to be_valid
    end

    context 'validates_presence_of' do
      it 'name为空值时无效' do
        admin = build(:admin, name: nil)
        admin.valid?
        expect(admin.errors[:name]).to include("can't be blank")
      end

      it 'nickname为空值时无效' do
        admin = build(:admin, nickname: nil)
        admin.valid?
        expect(admin.errors[:nickname]).to include("can't be blank")
      end
    end

    context 'validates_format_of' do
      it 'email格式不正确时无效' do
        admin = build(:admin, email: 'foobar')
        admin.valid?
        expect(admin.errors[:email]).to include('is invalid')
      end

      it 'email为空值时不做格式验证' do
        admin = Admin.new
        admin.valid?
        expect(admin.errors.keys).not_to include(:email)
      end
    end

    context 'validates_uniqueness_of' do
      before do
        @admin = create(:admin)
      end

      it 'name重复时无效' do
        another_admin = build(:admin, name: @admin.name)
        another_admin.valid?
        expect(another_admin.errors[:name]).to include('has already been taken')
      end


      it 'email重复时无效' do
        another_admin = build(:admin, email: @admin.email)
        another_admin.valid?
        expect(another_admin.errors[:email]).to include('has already been taken')
      end

      it 'email验证唯一性时不区分大小写' do
        another_admin = build(:admin, email: @admin.email.upcase)
        another_admin.valid?
        expect(another_admin.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe '实例方法' do
    before do
      @admin = create(:admin)
    end

    it '不调用remember方法时remember_digest为空值' do
      expect(@admin.remember_digest).to be_nil
    end

    it 'remember方法会生成remember_digest' do
      @admin.remember
      expect(@admin.remember_digest).not_to be_nil
    end

    it 'authenticated?方法在remember_token正确的情况下返回true' do
      @admin.remember
      remember_token = @admin.remember_token
      expect(@admin.authenticated?(remember_token)).to be_truthy
    end

    it 'authenticated?方法在remember_token不正确的情况下返回false' do
      @admin.remember
      expect(@admin.authenticated?(nil)).to be_falsey
    end

    it 'forget方法会清空remember_digest' do
      @admin.remember
      @admin.forget
      expect(@admin.remember_digest).to be_nil
    end
  end

  describe 'callback' do
    it '保存前会将email字符全部置为小写', skip_before: true do
      attrs = attributes_for(:admin)
      attrs[:email].upcase!
      admin = Admin.create(attrs)
      expect(admin.email).to eq attrs[:email].downcase
    end
  end
end
