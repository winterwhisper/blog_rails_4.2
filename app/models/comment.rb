class Comment < ActiveRecord::Base

  belongs_to :post, counter_cache: true

  validates_presence_of :body
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true

end
