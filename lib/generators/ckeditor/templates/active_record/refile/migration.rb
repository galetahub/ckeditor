class CreateCkeditorAssets < ActiveRecord::Migration
  def self.up
    create_table :ckeditor_assets do |t|
      t.string  :data_id, null: false
      t.string  :data_filename, null: false
      t.integer :data_size
      t.string  :data_content_type
      t.string  :type, limit: 30

      # Uncomment it to save images dimensions, if your need it
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end

    add_index :ckeditor_assets, :type
  end

  def self.down
    drop_table :ckeditor_assets
  end
end
