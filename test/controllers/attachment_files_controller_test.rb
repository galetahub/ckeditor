require 'test_helper'

class AttachmentFilesControllerTest < ActionController::TestCase
  tests Ckeditor::AttachmentFilesController

  include RawPost

  def setup
    @attachment = fixture_file_upload('files/rails.tar.gz', 'application/x-gzip')
    @routes = Ckeditor::Engine.routes
  end

  def teardown
    Ckeditor::AttachmentFile.destroy_all
  end

  test "index action" do
    get :index

    assert_equal 200, @response.status
    assert_template "ckeditor/attachment_files/index"
  end

  test "create action via filebrowser" do
    assert_difference 'Ckeditor::AttachmentFile.count' do
      post :create, :qqfile => @attachment
    end

    assert_equal 200, @response.status
  end

  test "create action via CKEditor upload form" do
    assert_difference 'Ckeditor::AttachmentFile.count' do
      post :create, :upload => @attachment, :CKEditor => 'ckeditor_field'
    end

    assert_equal 200, @response.status
  end

  test "create action via html5 upload" do
    assert_difference 'Ckeditor::AttachmentFile.count' do
      raw_post :create, { :qqfile => @attachment.original_filename }, @attachment.read
    end

    assert_equal 200, @response.status
  end

  test "invalid params for create action" do
    assert_no_difference 'Ckeditor::AttachmentFile.count' do
      post :create, :qqfile => nil, :format => :html
    end
  end

  test "destroy action via filebrowser" do
    @attachment_file = Ckeditor::AttachmentFile.create :data => @attachment

    assert_difference 'Ckeditor::AttachmentFile.count', -1 do
      delete :destroy, :id => @attachment_file.id
    end

    assert_equal 302, @response.status
  end
end
