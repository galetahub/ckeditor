# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Dragonfly

  dragonfly_accessor :data, app: :ckeditor
  validates :data, presence: true
end
