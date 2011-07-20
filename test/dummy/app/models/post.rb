case CKEDITOR_ORM

when :active_record
  class Post < ActiveRecord::Base
    validates_presence_of :title, :info, :content
  end

when :mongoid
  class Post
    include Mongoid::Document
    field :title
    field :info
    field :content
    validates_presence_of :title, :info, :content
  end

end
