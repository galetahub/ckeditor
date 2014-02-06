require 'test_helper'

class CkeditorTest < ActiveSupport::TestCase
  def teardown
    Ckeditor.picture_model = nil
    Ckeditor.attachment_file_model = nil
  end

  test "truth" do
    assert_kind_of Module, Ckeditor
  end

  test 'setup block yields self' do
    Ckeditor.setup do |config|
      assert_equal Ckeditor, config
    end
  end

  test 'default picture model' do
    assert_equal Ckeditor.picture_model, Ckeditor::Picture
  end

  test 'configuration specifying picture model' do
    Ckeditor.setup do |config|
      config.picture_model = CustomPicture
    end
    assert_equal Ckeditor.picture_model, CustomPicture
  end

  test 'configuration specifying picture model using block' do
    Ckeditor.setup do |config|
      config.picture_model { CustomPicture }
    end
    assert_equal Ckeditor.picture_model, CustomPicture
  end

  test 'picture model adapter' do
    assert_equal Ckeditor.picture_adapter, Ckeditor::Picture.to_adapter
  end

  test 'default attachment file model' do
    assert_equal Ckeditor.attachment_file_model, Ckeditor::AttachmentFile
  end

  test 'configuration specifying attachment file model' do
    Ckeditor.setup do |config|
      config.attachment_file_model = CustomAttachmentFile
    end
    assert_equal Ckeditor.attachment_file_model, CustomAttachmentFile
  end

  test 'configuration specifying attachment file model using block' do
    Ckeditor.setup do |config|
      config.attachment_file_model { CustomAttachmentFile }
    end
    assert_equal Ckeditor.attachment_file_model, CustomAttachmentFile
  end

  test 'attachment file model adapter' do
    assert_equal Ckeditor.attachment_file_adapter,
      Ckeditor::AttachmentFile.to_adapter
  end

  class CustomPicture; end
  class CustomAttachmentFile; end
end
