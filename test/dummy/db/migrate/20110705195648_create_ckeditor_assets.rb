class CreateCkeditorAssets < ActiveRecord::Migration
  def self.up
    create_table :ckeditor_assets do |t|
      t.string  :data_file_name
      t.string  :data_content_type
      t.integer :data_file_size
      
      # it's for carrierwave upload support
      t.string  :data
      
      t.integer :assetable_id
		  t.string  :assetable_type, :limit => 30
      t.string  :type, :limit => 30
		  
      # Uncomment	it to save images dimensions, if your need it
		  t.integer :width
		  t.integer :height
		  
      t.timestamps
    end
    
    add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"
		add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  end

  def self.down
    drop_table :ckeditor_assets
  end
end
