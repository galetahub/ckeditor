# frozen_string_literal: true

require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  tests Ckeditor::PicturesController

  def setup
    @image = fixture_file_upload('files/rails.png', 'image/png')
    @routes = Ckeditor::Engine.routes
  end

  def teardown
    Ckeditor::Picture.destroy_all
  end

  test 'index action' do
    get :index

    assert_equal 200, @response.status
    assert_template 'ckeditor/pictures/index'
  end

  test 'create action via filebrowser' do
    assert_difference 'Ckeditor::Picture.count' do
      post :create, params: { qqfile: @image }
    end

    assert_equal 200, @response.status
  end

  test 'create action via CKEditor upload form' do
    assert_difference 'Ckeditor::Picture.count' do
      post :create, params: { upload: @image, CKEditor: 'ckeditor_field' }
    end

    assert_equal 200, @response.status
  end

  test 'create action via html5 upload' do
    params = { qqfile: @image.original_filename }

    assert_difference 'Ckeditor::Picture.count' do
      post :create, params: params, body: @image.read
    end

    assert_equal 200, @response.status
  end

  test 'invalid params for create action' do
    assert_no_difference 'Ckeditor::Picture.count' do
      post :create, params: { qqfile: nil, format: :html }
    end
  end

  test 'destroy action via filebrowser' do
    @picture = Ckeditor::Picture.create data: @image

    assert_difference 'Ckeditor::Picture.count', -1 do
      delete :destroy, params: { id: @picture.id }
    end

    assert_equal 302, @response.status
  end
end
