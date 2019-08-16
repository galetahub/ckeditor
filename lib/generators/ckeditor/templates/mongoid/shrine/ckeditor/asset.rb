# frozen_string_literal: true

class Ckeditor::Asset
  include Ckeditor::Orm::Mongoid::AssetBase
  include Ckeditor::Backend::Shrine

  field :data_data, type: Hash
end
