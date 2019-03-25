# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @post = Post.create!(title: 'test', content: 'content', info: 'info')
  end

  def teardown
    @post.destroy rescue nil
  end

  test 'include javascripts' do
    get :index

    assert_select 'script', Regexp.new("CKEDITOR\\.replace\\('test_area'")
  end

  test 'pass text_area with options' do
    get :show, params: { id: @post }

    assert_select "textarea[name='content']", 'Ckeditor'
    assert_select 'script', Regexp.new("CKEDITOR\\.replace\\('content',\s\{\"toolbar\":\"Easy\"")
  end

  test 'form builder helper' do
    get :new

    assert_select "textarea[name='post[content]']", ''
    assert_select 'script', Regexp.new("CKEDITOR\\.replace\\('post_content',\s\{\"width\":800,\"height\":400")
    assert_select "textarea[name='post[info]']", 'Defaults info content'
    assert_select 'script', Regexp.new("CKEDITOR\\.replace\\('new_info_content'")
  end

  test 'text_area value' do
    get :edit, params: { id: @post }

    assert_select "textarea[name='post[content]']", 'content'
    assert_select "textarea[name='post[info]']", 'info'
  end
end
