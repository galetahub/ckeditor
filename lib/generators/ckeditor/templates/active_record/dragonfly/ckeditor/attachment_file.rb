class Ckeditor::AttachmentFile < Ckeditor::Asset
  validates_property :ext, of: :data, in: attachment_file_types unless attachment_file_types.empty?

  def url_thumb
    Ckeditor::Utils.filethumb(filename)
  end
end
