require 'mime/types'

class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase

  attr_accessible :data, :assetable_type, :assetable_id, :assetable
end
