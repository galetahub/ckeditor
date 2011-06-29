require 'mime/types'
require 'ckeditor/orm/active_record'

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  
  attr_accessible :data, :assetable_type, :assetable_id, :assetable
end
