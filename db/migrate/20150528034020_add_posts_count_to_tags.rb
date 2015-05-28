class AddPostsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :posts_count, :integer, null: false, default: 0
  end
end
