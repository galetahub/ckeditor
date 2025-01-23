# frozen_string_literal: true

class Ckeditor::Asset < ApplicationRecord
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Paperclip
end
