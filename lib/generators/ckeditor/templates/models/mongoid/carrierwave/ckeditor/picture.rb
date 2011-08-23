class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader
	
	def url_content
	  url(:content)
	end
end
