class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
              
  delegate :url, :current_path, :size, :content_type, :filename, :to => :data
end
