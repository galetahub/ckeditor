require 'test_helper'

class CkeditorTest < ActiveSupport::TestCase
  def teardown
    Ckeditor.picture_model = nil
    Ckeditor.attachment_file_model = nil
    Ckeditor.cdn_url = nil
    Ckeditor.assets = nil
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

  test 'languages ingnore list' do
    Ckeditor.assets = nil
    Ckeditor.assets_languages = ['en', 'uk']

    assert_equal Ckeditor.assets.include?('ckeditor/lang/ru.js'), false
    assert_equal Ckeditor.assets.include?('ckeditor/lang/en.js'), true
    assert_equal Ckeditor.assets.include?('ckeditor/lang/uk.js'), true
    assert_equal Ckeditor.assets.include?('ckeditor/plugins/a11yhelp/dialogs/lang/bg.js'), false
    assert_equal Ckeditor.assets.include?('ckeditor/plugins/a11yhelp/dialogs/lang/uk.js'), true
  end

  test 'plugins ingnore list' do
    Ckeditor.assets = nil
    Ckeditor.assets_plugins = ['image']

    assert_equal Ckeditor.assets.include?('ckeditor/plugins/table/dialogs/table.js'), false
    assert_equal Ckeditor.assets.include?('ckeditor/plugins/image/dialogs/image.js'), true
  end

  test 'configuration specifying running ckeditor:nondigest task on assets:precompile' do
    assert_equal Ckeditor.run_on_precompile?, true
    Ckeditor.run_on_precompile = false
    assert_equal Ckeditor.run_on_precompile?, false
  end

  test 'CDN setup' do
    Ckeditor.cdn_url = '//cdn.ckeditor.com/4.5.6/standard/ckeditor.js'
    Ckeditor.assets = nil

    assert_equal Ckeditor.cdn_enabled?, true
    assert_equal Ckeditor.assets, ['ckeditor/config.js']
  end

  class CustomPicture; end
  class CustomAttachmentFile; end
end
