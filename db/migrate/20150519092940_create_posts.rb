class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.datetime :taken_at
      t.belongs_to :user, index: true, foreign_key: true
      t.string :description

      t.timestamps null: false
    end
  end
end
