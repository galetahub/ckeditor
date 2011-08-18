require 'mime/types'

class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase
  include Mongoid::Paperclip

  before_validation :extract_content_type
  before_create :read_dimensions, :parameterize_filename

  delegate :url, :path, :styles, :size, :content_type, :to => :data
end
