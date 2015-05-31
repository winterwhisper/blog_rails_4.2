class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :nickname, null: false
      t.string :password_digest, null: false
      t.string :remember_digest

      t.timestamps null: false
    end
  end
end
