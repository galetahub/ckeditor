# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  def url_thumb
    Ckeditor::Utils.filethumb(filename)
  end
end
