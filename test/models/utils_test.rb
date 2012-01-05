require 'test_helper'

class UtilsTest < ActiveSupport::TestCase
  test 'exists filethumb' do
    ["avi", "doc", "docx", "exe", "gz", "htm", "jpg", "mp3", "mpg", "pdf", 
     "psd", "rar", "swf", "tar", "txt", "wmv", "xlsx", "zip"].each do |ext|
      assert_equal Ckeditor::Utils.filethumb("somefile.#{ext}"), "/assets/ckeditor/filebrowser/images/thumbs/#{ext}.gif"
    end
    
    assert_equal Ckeditor::Utils.filethumb("somefile.ddd"), "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif"
  end
  
  test 'wrong filethumb' do    
    assert_equal Ckeditor::Utils.filethumb("somefile.ddd"), "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif"
    assert_equal Ckeditor::Utils.filethumb("somefile"), "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif"
    assert_equal Ckeditor::Utils.filethumb(""), "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif"
    assert_equal Ckeditor::Utils.filethumb(nil), "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif"
  end
end
