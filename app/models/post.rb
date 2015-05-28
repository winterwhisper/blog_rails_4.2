class Post < ActiveRecord::Base

  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates_presence_of :title, :body

end
