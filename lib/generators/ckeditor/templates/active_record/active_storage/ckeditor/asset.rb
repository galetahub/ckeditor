# frozen_string_literal: true

class Ckeditor::Asset < ApplicationRecord
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::ActiveStorage

  attr_accessor :data

  has_one_attached :storage_data
end
