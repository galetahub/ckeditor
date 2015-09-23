class Ckeditor::AttachmentFile < Ckeditor::Asset
  attachment :data, extension: attachment_file_types

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
