require 'orm_adapter'
require 'pathname'

module Ckeditor
  autoload :Utils, 'ckeditor/utils'
  autoload :Http, 'ckeditor/http'
  autoload :TextArea, 'ckeditor/text_area'
  autoload :Paginatable, 'ckeditor/paginatable'
  autoload :AssetResponse, 'ckeditor/asset_response'

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

  IMAGE_TYPES = %w[image/jpeg image/png image/gif image/jpg image/pjpeg image/tiff image/x-png].freeze

  DEFAULT_AUTHORIZE = -> {}

  AUTHORIZATION_ADAPTERS = {}

  DEFAULT_CURRENT_USER = lambda do
    request.env['warden'].try(:user) || respond_to?(:current_user) && current_user
  end

  # Allowed image file types for upload.
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :image_file_types
  @@image_file_types = %w[jpg jpeg png gif tiff]

  # Allowed flash file types for upload.
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :flash_file_types
  @@flash_file_types = %w[swf]

  # Allowed attachment file types for upload.
  # Set to nil or [] (empty array) for all file types
  mattr_accessor :attachment_file_types
  @@attachment_file_types = %w[doc docx xls odt ods pdf rar zip tar tar.gz swf]

  # Ckeditor files destination path
  mattr_accessor :relative_path
  @@relative_path = 'ckeditor'

  # Ckeditor assets path
  mattr_accessor :asset_path
  @@asset_path = nil

  # Remove digest from ckeditor asset files while running assets:precompile task?
  mattr_accessor :run_on_precompile
  @@run_on_precompile = true

  # Paginate assets
  mattr_accessor :default_per_page
  @@default_per_page = 24

  # Asset restrictions
  mattr_accessor :assets_languages
  mattr_accessor :assets_plugins
  @@assets_languages = nil
  @@assets_plugins = nil

  # CKEditor CDN
  mattr_accessor :cdn_url
  @@cdn_url = nil

  # Url to ckeditor config, used when CDN enabled
  mattr_accessor :js_config_url
  @@js_config_url = 'ckeditor/config.js'

  # Model classes
  @@picture_model = nil
  @@attachment_file_model = nil

  # Configurable parent controller
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  # Configurable controller layout
  mattr_accessor :controller_layout
  @@controller_layout = 'ckeditor/application'

  # Turn on/off assets pipeline
  # By default ckeditor will check assets pipeline
  mattr_accessor :assets_pipeline_enabled
  @@assets_pipeline_enabled = nil

  # Default way to setup Ckeditor. Run rails generate ckeditor to create
  # a fresh initializer with all configuration values.
  #
  # @example
  #   Ckeditor.setup do |config|
  #     config.default_per_page = 30
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
    @assets ||= if Ckeditor.cdn_enabled?
                  ['ckeditor/config.js']
                else
                  Utils.select_assets('ckeditor', 'vendor/assets/javascripts') << 'ckeditor/init.js'
                end
  end

  def self.assets=(value)
    @assets = value.nil? ? nil : Array(value)
  end

  def self.run_on_precompile?
    @@run_on_precompile
  end

  def self.cdn_enabled?
    !@@cdn_url.nil?
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
      @authorize = lambda do
        @authorization_adapter = Ckeditor::AUTHORIZATION_ADAPTERS[extension].new(*([self] + args).compact)
      end
    elsif block_given?
      @authorize = block
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
    @current_user = block if block_given?
    @current_user || DEFAULT_CURRENT_USER
  end

  def self.assets_pipeline_enabled?
    @@assets_pipeline_enabled = Utils.assets_pipeline_enabled? if @@assets_pipeline_enabled.nil?
    @@assets_pipeline_enabled
  end
end

require 'ckeditor/rails'
require 'ckeditor/version'
