class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_attached_file :data,
                    :url => "/ckeditor_assets/attachments/:id/:filename",
                    :path => ":rails_root/public/ckeditor_assets/attachments/:id/:filename"
  
  validates_attachment_size :data, :less_than => 100.megabytes
  validates_attachment_presence :data
	
	def url_thumb
	  @url_thumb ||= Ckeditor::Utils.filethumb(filename)
	end
end
