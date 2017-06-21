class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase

  delegate :url, :current_path, :content_type, to: :data

  validates :data, presence: true
end
