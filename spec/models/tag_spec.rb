require 'rails_helper'

describe Tag do
  describe 'validators' do
    it 'value有值时有效' do
      expect(build(:tag)).to be_valid
    end

    context 'validates_presence_of' do
      it 'value为空值时无效' do
        tag = build(:tag, value: nil)
        tag.valid?
        expect(tag.errors[:value]).to include("can't be blank")
      end
    end
  end

  describe 'associations' do
    context 'posts' do
      it '没有时posts_count应该为0' do
        expect(create(:tag).posts_count).to eq 0
      end

      it '增加时posts_count会对应增加' do
        expect(create(:tag, with_post: true).posts_count).to eq 1
      end
    end
  end

  describe '类方法' do
    it "split_tags_value会将传入的字符串参数按#{Tag::SPLIT_STR}分割并返回数组" do
      values = Tag.split_tags_value('foo, bar')
      expect(values).to include('foo', ' bar')
    end
  end

  describe 'callback' do
    it 'value的前后存在空格时会自动去除' do
      tag = create(:tag_value_with_whitespace)
      expect(tag.value).to eq(tag.value.strip)
    end
  end
end