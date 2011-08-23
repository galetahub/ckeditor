class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase
  include Mongoid::Paperclip
  include Ckeditor::Backend::Paperclip
end
