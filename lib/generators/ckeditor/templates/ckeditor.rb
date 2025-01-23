# frozen_string_literal: true

# Use this hook to configure ckeditor
Ckeditor.setup do |config|
  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default), :mongo_mapper and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'ckeditor/orm/<%= options[:orm] %>'

  # Allowed image file types for upload.
  # Set to nil or [] (empty array) for all file types
  # By default: %w(jpg jpeg png gif tiff)
  config.image_file_types = %w[jpg jpeg png gif tiff]

  # Allowed flash file types for upload.
  # Set to nil or [] (empty array) for all file types
  # By default: %w(jpg jpeg png gif tiff)
  # config.flash_file_types = %w[swf]

  # Allowed attachment file types for upload.
  # Set to nil or [] (empty array) for all file types
  # By default: %w(doc docx xls odt ods pdf rar zip tar tar.gz swf)
  config.attachment_file_types = %w[doc docx xls odt ods pdf rar zip tar tar.gz swf]

  # Setup authorization to be run as a before filter
  # By default: there is no authorization.
  # config.authorize_with :cancancan

  # Override parent controller CKEditor inherits from
  # By default: 'ApplicationController'
  # config.parent_controller = 'MyController'

  # Asset model classes
  # config.picture_model { Ckeditor::Picture }
  # config.attachment_file_model { Ckeditor::AttachmentFile }

  # Paginate assets
  # By default: 24
  config.default_per_page = 24

  # Customize ckeditor assets path
  # By default: nil
  # config.asset_path = 'http://www.example.com/assets/ckeditor/'

  # CKEditor CDN
  # More info here http://cdn.ckeditor.com/
  # By default: nil (CDN disabled)
  # config.cdn_url = '//cdn.ckeditor.com/<%= Ckeditor::Version::EDITOR %>/standard/ckeditor.js'

  # JS config url
  # Used when CKEditor CDN enabled
  # By default: "ckeditor/config.js"
  # config.js_config_url = 'ckeditor/config.js'
end
