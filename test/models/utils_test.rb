require 'test_helper'

class UtilsTest < ActiveSupport::TestCase
  test 'exists filethumb' do
    ["avi", "doc", "docx", "exe", "gz", "htm", "jpg", "mp3", "mpg", "pdf", 
     "psd", "rar", "swf", "tar", "txt", "wmv", "xlsx", "zip"].each do |ext|
      assert_equal "/assets/ckeditor/filebrowser/images/thumbs/#{ext}.gif", Ckeditor::Utils.filethumb("somefile.#{ext}")
    end
    
    assert_equal "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif", Ckeditor::Utils.filethumb("somefile.ddd")
  end
  
  test 'wrong filethumb' do    
    assert_equal "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif", Ckeditor::Utils.filethumb("somefile.ddd")
    assert_equal "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif", Ckeditor::Utils.filethumb("somefile")
    assert_equal "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif", Ckeditor::Utils.filethumb("")
    assert_equal "/assets/ckeditor/filebrowser/images/thumbs/unknown.gif", Ckeditor::Utils.filethumb(nil)
  end
end
