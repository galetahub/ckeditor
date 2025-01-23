# frozen_string_literal: true

class Ckeditor::Asset < ApplicationRecord
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Dragonfly

  dragonfly_accessor :data, app: :ckeditor
  validates :data, presence: true
end
