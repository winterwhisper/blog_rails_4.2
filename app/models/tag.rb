class Tag < ActiveRecord::Base

  SPLIT_STR = ','

  has_many :post_tags
  has_many :posts, through: :post_tags

  validates_presence_of :value

  before_save :strip_value

  def self.split_tags_value(tag)
    tag.split(Tag::SPLIT_STR)
  end

  private

    def strip_value
      self.value.strip!
    end

end
