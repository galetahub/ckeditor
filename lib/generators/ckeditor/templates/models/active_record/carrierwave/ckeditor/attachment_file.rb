class Ckeditor::AttachmentFile < Ckeditor::Asset
  mount_uploader :data, CkeditorAttachmentFileUploader
	
	def url_thumb
	  @url_thumb ||= begin
	    extname = File.extname(filename).gsub(/^\./, '')
      "/javascripts/ckeditor/filebrowser/images/thumbs/#{extname}.gif"
	  end
	end
end
