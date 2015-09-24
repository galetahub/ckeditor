require 'orm_adapter'
require 'pathname'

module Ckeditor
  autoload :Utils, 'ckeditor/utils'
  autoload :Http, 'ckeditor/http'
  autoload :TextArea, 'ckeditor/text_area'
  autoload :Paginatable, 'ckeditor/paginatable'

  module Helpers
    autoload :ViewHelper, 'ckeditor/helpers/view_helper'
    autoload :FormHelper, 'ckeditor/helpers/form_helper'
    autoload :FormBuilder, 'ckeditor/helpers/form_builder'
    autoload :Controllers, 'ckeditor/helpers/controllers'
  end

  module Hooks
    autoload :SimpleFormBuilder, 'ckeditor/hooks/simple_form'
    autoload :CanCanAuthorization, 'ckeditor/hooks/cancan'
    autoload :PunditAuthorization, 'ckeditor/hooks/pundit'
  end

  module Backend
    autoload :Paperclip, 'ckeditor/backend/paperclip'
    autoload :CarrierWave, 'ckeditor/backend/carrierwave'
    autoload :Dragonfly, 'ckeditor/backend/dragonfly'
    autoload :Refile, 'ckeditor/backend/refile'
  end

  IMAGE_TYPES = %w(image/jpeg image/png image/gif image/jpg image/pjpeg image/tiff image/x-png)

  DEFAULT_AUTHORIZE = Proc.new {}

  AUTHORIZATION_ADAPTERS = {}

  DEFAULT_CURRENT_USER = Proc.new do
    request.env["warden"].try(:user) || respond_to?(:current_user) && current_user
  end

  # Allowed image file types for upload.
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :image_file_types
  @@image_file_types = %w(jpg jpeg png gif tiff)

  # Allowed attachment file types for upload.
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :attachment_file_types
  @@attachment_file_types = %w(doc docx xls odt ods pdf rar zip tar tar.gz swf)

  # Ckeditor files destination path
  mattr_accessor :relative_path
  @@relative_path = 'ckeditor'

  # Ckeditor assets path
  mattr_accessor :asset_path
  @@asset_path = nil

  # Ckeditor assets for precompilation
  mattr_accessor :assets
  @@assets = nil

  # Remove digest from ckeditor asset files while running assets:precompile task?
  mattr_accessor :run_on_precompile
  @@run_on_precompile = true

  # Turn on/off filename parameterize
  mattr_accessor :parameterize_filenames
  @@parameterize_filenames = true

  # Paginate assets
  mattr_accessor :default_per_page
  @@default_per_page = 24

  # Asset restrictions
  mattr_accessor :assets_languages
  mattr_accessor :assets_plugins
  @@assets_languages = nil
  @@assets_plugins = nil

  # Model classes
  @@picture_model = nil
  @@attachment_file_model = nil

  # Default way to setup Ckeditor. Run rails generate ckeditor to create
  # a fresh initializer with all configuration values.
  #
  # @example
  #   Ckeditor.setup do |config|
  #     config.parameterize_filenames = false
  #     config.attachment_file_types += ["xml"]
  #   end
  #
  def self.setup
    yield self
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end

  def self.base_path
    @base_path ||= (asset_path || File.join([Rails.application.config.assets.prefix, '/ckeditor/']))
  end

  # All css and js files from ckeditor folder
  def self.assets
    @@assets ||= Utils.select_assets("ckeditor", "vendor/assets/javascripts") << "ckeditor/init.js"
  end

  def self.run_on_precompile?
    @@run_on_precompile
  end

  def self.picture_model(&block)
    if block_given?
      self.picture_model = block
    else
      @@picture_model_class ||= begin
        if @@picture_model.respond_to? :call
          @@picture_model.call
        else
          @@picture_model || Ckeditor::Picture
        end
      end
    end
  end

  def self.picture_model=(value)
    @@picture_model_class = nil
    @@picture_model = value
  end

  def self.picture_adapter
    picture_model.to_adapter
  end

  def self.attachment_file_model(&block)
    if block_given?
      self.attachment_file_model = block
    else
      @@attachment_file_model_class ||= begin
        if @@attachment_file_model.respond_to? :call
          @@attachment_file_model.call
        else
          @@attachment_file_model || Ckeditor::AttachmentFile
        end
      end
    end
  end

  def self.attachment_file_model=(value)
    @@attachment_file_model_class = nil
    @@attachment_file_model = value
  end

  def self.attachment_file_adapter
    attachment_file_model.to_adapter
  end

  # Setup authorization to be run as a before filter
  # This is run inside the controller instance so you can setup any authorization you need to.
  #
  # By default, there is no authorization.
  #
  # @example Custom
  #   Ckeditor.setup do |config|
  #     config.authorize_with do
  #       redirect_to root_path unless warden.user.is_admin?
  #     end
  #   end
  #
  # To use an authorization adapter, pass the name of the adapter. For example,
  # to use with CanCan[https://github.com/ryanb/cancan], pass it like this.
  #
  # @example CanCan
  #   Ckeditor.setup do |config|
  #     config.authorize_with :cancan
  #   end
  #
  def self.authorize_with(*args, &block)
    extension = args.shift

    if extension
      @authorize = Proc.new {
        @authorization_adapter = Ckeditor::AUTHORIZATION_ADAPTERS[extension].new(*([self] + args).compact)
      }
    else
      @authorize = block if block
    end

    @authorize || DEFAULT_AUTHORIZE
  end

  # Setup a different method to determine the current user or admin logged in.
  # This is run inside the controller instance and made available as a helper.
  #
  # By default, request.env["warden"].user or current_user will be used.
  #
  # @example Custom
  #   Ckeditor.setup do |config|
  #     config.current_user_method do
  #       current_account
  #     end
  #   end
  #
  def self.current_user_method(&block)
    @current_user = block if block
    @current_user || DEFAULT_CURRENT_USER
  end
end

require 'ckeditor/engine'
require 'ckeditor/version'
