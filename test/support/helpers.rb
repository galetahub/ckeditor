require 'active_support/test_case'
require 'action_dispatch/testing/test_process'

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  
  def new_attachemnt(data = nil)
    data ||= fixture_file_upload('files/rails.tar.gz', 'application/x-gzip')
    
    Ckeditor::AttachmentFile.new(:data => data)
  end
  
  def create_attachemnt(data = nil)
    attachemnt = new_attachemnt(data)
    attachemnt.save!
    attachemnt
  end
  
  def new_picture(data = nil)
    data ||= fixture_file_upload('files/rails.png', 'image/png')
    
    Ckeditor::Picture.new(:data => data)
  end
  
  def create_picture(data = nil)
    picture = new_picture(data)
    picture.save!
    picture
  end
end
