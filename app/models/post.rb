class Post < ActiveRecord::Base

  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags

  accepts_nested_attributes_for :tags

  validates_presence_of :title, :body

  before_save :split_and_renew_tags
  after_save :increase_tags_posts_count

  private

    def split_and_renew_tags
      tags_value = self.tags.first.value.split(Tag::SPLIT_STR)
      self.tags = []
      tags_value.each { |t| self.tags << Tag.find_or_initialize_by(value: t) }
    end

    def increase_tags_posts_count
      Tag.increment_counter(:posts_count, tags.pluck(:id))
    end

end
