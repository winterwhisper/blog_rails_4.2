class Post < ActiveRecord::Base

  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags

  attr_accessor :pending_tags

  validates_presence_of :title, :body

  before_save :split_and_renew_tags

  private

    def split_and_renew_tags
      if pending_tags.present?
        pending_tags_value = Tag.split_tags_value(pending_tags)
        old_tags_value = self.tags.pluck(:value)
        new_tags_value = (old_tags_value + pending_tags_value).uniq - old_tags_value
        new_tags_value.each { |t| self.tags << Tag.create(value: t) }
      end
    end

end
