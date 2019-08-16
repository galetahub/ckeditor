# frozen_string_literal: true

module Ckeditor
  class AttachmentFileUploader < Shrine
    plugin :validation_helpers

    Attacher.validate do
      validate_max_size 100.megabytes
    end
  end

  class AttachmentFile < Ckeditor::Asset
    include AttachmentFileUploader.attachment(:data)

    validates :data, presence: true

    def url_thumb
      @url_thumb ||= Ckeditor::Utils.filethumb(filename)
    end
  end
end
