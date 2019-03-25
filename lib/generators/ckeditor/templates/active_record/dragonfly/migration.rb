# frozen_string_literal: true

class CreateCkeditorAssets < ActiveRecord::Migration[5.2]
  def up
    create_table :ckeditor_assets do |t|
      t.string  :data_uid, null: false
      t.string  :data_name, null: false
      t.string  :data_mime_type
      t.integer :data_size
      t.string  :type, limit: 30

      # Uncomment these to save image dimensions, if your need them.
      # t.integer :data_width
      # t.integer :data_height

      t.timestamps null: false
    end

    add_index :ckeditor_assets, :type
  end

  def down
    drop_table :ckeditor_assets
  end
end
