# frozen_string_literal: true

module Ckeditor
  class AttachmentFile < Ckeditor::Asset
    include CkeditorAttachmentFileUploader.attachment(:data)

    validates :data, presence: true

    def url_thumb
      @url_thumb ||= Ckeditor::Utils.filethumb(filename)
    end
  end
end
