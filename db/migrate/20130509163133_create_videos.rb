class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :external_id
      t.text :video_url
      t.string :thumbnail_url
      t.integer :length
      t.references :room

      t.timestamps
    end
    add_index :videos, :room_id
  end
end
