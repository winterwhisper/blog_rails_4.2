require 'rails_helper'

describe Comment do

  it '当username, email, body有值，email格式正确时有效' do
    comment = build(:comment)
    comment.valid?
    expect(comment).to be_valid
  end

  it 'body为空值时无效' do
    comment = build(:comment, body: nil)
    comment.valid?
    expect(comment.errors[:body]).to include("can't be blank")
  end

  it 'email为空值时不做格式验证' do
    comment = Comment.new
    comment.valid?
    expect(comment.errors.keys).not_to include(:email)
  end

  it 'email格式不正确时无效' do
    comment = build(:comment, email: 'foobar')
    comment.valid?
    expect(comment.errors[:email]).to include('is invalid')
  end

end