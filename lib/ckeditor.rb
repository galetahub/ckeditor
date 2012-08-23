require 'orm_adapter'
require 'pathname'

module Ckeditor
  IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg', 'image/tiff', 'image/x-png']
  
  autoload :Utils, 'ckeditor/utils'
  autoload :Http, 'ckeditor/http'
  
  module Helpers
    autoload :ViewHelper, 'ckeditor/helpers/view_helper'
    autoload :FormHelper, 'ckeditor/helpers/form_helper'
    autoload :FormBuilder, 'ckeditor/helpers/form_builder'
    autoload :Controllers, 'ckeditor/helpers/controllers'
  end
  
  module Hooks
    autoload :SimpleFormBuilder, 'ckeditor/hooks/simple_form'
  end
  
  module Backend
    autoload :Paperclip, 'ckeditor/backend/paperclip'
    autoload :CarrierWave, 'ckeditor/backend/carrierwave'
    autoload :Dragonfly, 'ckeditor/backend/dragonfly'
  end
  
  # Allowed image file types for upload. 
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :image_file_types
  @@image_file_types = ["jpg", "jpeg", "png", "gif", "tiff"]
  
  # Allowed attachment file types for upload. 
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :attachment_file_types
  @@attachment_file_types = ["doc", "docx", "xls", "odt", "ods", "pdf", "rar", "zip", "tar", "tar.gz", "swf"]
  
  # Ckeditor files destination path
  mattr_accessor :relative_path
  @@relative_path = '/assets/ckeditor'
  
  # Ckeditor assets for precompilation
  mattr_accessor :assets
  @@assets = nil

  # Turn on/off filename parameterize
  mattr_accessor :parameterize_filenames
  @@parameterize_filenames = true
  
  # Default way to setup Ckeditor. Run rails generate ckeditor to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
  
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
  
  def self.assets
    @@assets ||= begin
      Utils.select_assets("vendor/assets/javascripts/ckeditor", "vendor/assets/javascripts") +
      Utils.select_assets("app/assets/javascripts/ckeditor/plugins", "app/assets/javascripts")
    end
  end
  
  def self.picture_model
    Ckeditor::Picture.to_adapter
  end
  
  def self.attachment_file_model
    Ckeditor::AttachmentFile.to_adapter
  end
end

require 'ckeditor/engine'
require 'ckeditor/version'
