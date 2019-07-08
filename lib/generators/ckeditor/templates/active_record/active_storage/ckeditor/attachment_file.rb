# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  # for validation, see https://github.com/igorkasyanchuk/active_storage_validations

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
