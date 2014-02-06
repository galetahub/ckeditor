class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase

  delegate :url, :current_path, :size, :content_type, :filename, :to => :data

  validates_presence_of :data
end
