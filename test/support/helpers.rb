require 'active_support/test_case'
require 'action_dispatch/testing/test_process'

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  def new_attachment(data = nil)
    data ||= fixture_file_upload('files/rails.tar.gz', 'application/x-gzip')

    Ckeditor.attachment_file_model.new(:data => data)
  end

  def create_attachment(data = nil)
    attachment = new_attachment(data)
    attachment.save!
    attachment
  end

  def new_picture(data = nil)
    data ||= fixture_file_upload('files/rails.png', 'image/png')

    Ckeditor.picture_model.new(:data => data)
  end

  def create_picture(data = nil)
    picture = new_picture(data)
    picture.save!
    picture
  end
end
