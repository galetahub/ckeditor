# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  include AttachmentFileUploader.attachment(:data)

  validates :data, presence: true

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
