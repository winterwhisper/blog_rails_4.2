require 'rails_helper'

describe Tag do

  it 'value为空值时无效' do
    tag = Tag.new(value: nil)
    tag.valid?
    expect(tag.errors[:value]).to include("can't be blank")
  end

  it 'value有值时有效' do
    tag = Tag.new(value: 'foo')
    expect(tag).to be_valid
  end

  it 'value的前后存在空格时会自动去除' do
    tag = Tag.create(value: ' foo ')
    expect(tag.value).to eq('foo')
  end

  it '没有所属文章时posts_count应该为0' do
    tag = Tag.create(value: 'foo')
    expect(tag.posts_count).to eq 0
  end

  it '所属文章增加时posts_count会对应增加' do
    tag = Tag.create(value: 'foo')
    tag.posts.create(
      title: 'foo',
      body: 'foo'
    )
    expect(tag.posts_count).to eq 1
  end

  it "类方法split_tags_value会将传入的字符串参数按#{Tag::SPLIT_STR}分割并返回数组" do
    values = Tag.split_tags_value('foo, bar')
    expect(values).to include('foo', ' bar')
  end

end