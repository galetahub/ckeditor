class CreateCkeditorAssets < ActiveRecord::Migration
  def self.up
    create_table :ckeditor_assets do |t|
      t.string  :data, :null => false
      
      t.integer :assetable_id
		  t.string  :assetable_type, :limit => 30
      t.string  :type, :limit => 30
		  
      t.timestamps
    end
    
    add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"
		add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  end

  def self.down
    drop_table :ckeditor_assets
  end
end
