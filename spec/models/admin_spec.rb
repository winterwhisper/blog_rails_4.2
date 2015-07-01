require 'rails_helper'

describe Admin do
  describe 'validators' do
    it 'name, nickname, password, email有值，且email格式正确，email, name不重复时有效' do
      create(:admin)
      admin = build_stubbed(:admin)
      admin.valid?
      expect(admin).to be_valid
    end

    context 'validate_presence_of' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:nickname) }
    end

    context 'validates_format_of' do
      it { should allow_value(nil).for(:email) }
      it { should_not allow_value('foobar').for(:email) }
    end

    context 'validates_uniqueness_of' do
      subject { build(:admin) }
      it { should validate_uniqueness_of(:name).case_insensitive }
      it { should validate_uniqueness_of(:email).case_insensitive }
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
