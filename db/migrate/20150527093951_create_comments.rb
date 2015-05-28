class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :username
      t.string :email
      t.string :body, null: false, length: 65535

      t.timestamps null: false
    end
  end
end
