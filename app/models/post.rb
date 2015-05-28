class Post < ActiveRecord::Base

  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates_presence_of :title, :body

  after_save :increase_tags_posts_count

  private

    def increase_tags_posts_count
      Tag.increment_counter(:posts_count, tags.pluck(:id))
    end

end
