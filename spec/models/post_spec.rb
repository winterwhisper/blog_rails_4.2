require 'rails_helper'

describe Post do

  it 'title为空值时无效' do
    post = Post.new(title: nil)
    post.valid?
    expect(post.errors[:title]).to include("can't be blank")
  end

  it 'body为空值时无效' do
    post = Post.new(body: nil)
    post.valid?
    expect(post.errors[:body]).to include("can't be blank")
  end

  it 'title/body都有值时有效' do
    post = Post.new(
      title: 'foobar',
      body: 'foobar'
    )
    expect(post).to be_valid
  end

  it '没有所属评论的时候comments_count应该为0' do
    post = Post.create(
      title: 'foobar',
      body: 'foobar'
    )
    expect(post.comments_count).to eq 0
  end

  it '所属评论增加时comments_count会对应增加' do
    post = Post.create(
      title: 'foobar',
      body: 'foobar'
    )
    post.comments.create(body: 'foobar')
    expect(post.comments_count).to eq 1
  end

  it '所属标签重复时不会新建' do
    post = Post.create(
      title: 'foobar',
      body: 'foobar',
      pending_tags: 'foobar'
    )
    post.pending_tags = 'foobar, foobar2'
    post.save
    expect(Tag.count).to eq 2
  end

  it '所属标签值为空格时不新建空白的标签' do
    post = Post.create(
      title: 'foobar',
      body: 'foobar',
      pending_tags: '   '
    )
    expect(Tag.count).to eq 0
  end

end