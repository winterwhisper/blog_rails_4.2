require 'rails_helper'

describe Post do
  describe 'validators' do
    it 'title/body都有值时有效' do
      expect(build_stubbed(:post)).to be_valid
    end

    context 'validates_presence_of' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:body) }
    end
  end

  describe 'associations' do
    context 'comments' do
      it '没有的时候comments_count应该为0' do
        expect(create(:post).comments_count).to eq 0
      end

      it '增加时comments_count会对应增加' do
        expect(create(:post, with_comment: true).comments_count).to eq 1
      end
    end

    context 'tags' do
      it '重复时不会新建' do
        post = create(:post_with_valid_pending_tags)
        post.pending_tags = 'foobar tag, foobar tag2'
        post.save
        expect(Tag.count).to eq 2
      end

      it '值为空格时不新建空白的标签' do
        post = create(:post_with_null_value_pending_tags)
        expect(Tag.count).to eq 0
      end
    end
  end
end