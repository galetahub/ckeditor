# frozen_string_literal: true

class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase
  include Mongoid::Paperclip
  include Ckeditor::Backend::Paperclip
end
