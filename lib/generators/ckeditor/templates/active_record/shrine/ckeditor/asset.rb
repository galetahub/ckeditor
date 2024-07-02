# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Shrine

  include CkeditorAttachmentUploader::Attachment(:attachment)

  validates :attachment_data, presence: true
end
