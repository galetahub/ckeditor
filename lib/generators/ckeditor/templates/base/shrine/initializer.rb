# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'
require 'ckeditor/backend/shrine'

# Choose your favorite image processor
require 'image_processing/mini_magick'
SHRINE_PICTURE_PROCESSOR = ImageProcessing::MiniMagick

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new('public', prefix: 'system')
}

Shrine.plugin :mongoid
Shrine.plugin :activerecord

Shrine.plugin :determine_mime_type
Shrine.plugin :instrumentation

Shrine.plugin :validation_helpers
Shrine.plugin :processing
Shrine.plugin :versions
