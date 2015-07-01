require 'rails_helper'

describe Comment do
  describe 'validators' do
    it '当username, email, body有值，email格式正确时有效' do
      comment = build_stubbed(:comment)
      comment.valid?
      expect(comment).to be_valid
    end

    context 'validates_presence_of' do
      it { should validate_presence_of(:body) }
    end

    context 'validates_format_of' do
      it { should allow_value(nil).for(:email) }
      it { should_not allow_value('foobar').for(:email) }
    end
  end
end