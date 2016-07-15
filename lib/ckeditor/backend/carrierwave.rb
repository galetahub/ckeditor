require 'mini_magick'

module Ckeditor
  module Backend
    module CarrierWave
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def self.extended(base)
          base.class_eval do
            process :extract_content_type
            process :extract_size
          end
        end
      end

      module InstanceMethods
        # process :strip
        def strip
          manipulate! do |img|
            img.strip
            img = yield(img) if block_given?
            img
          end
        end

        # process :quality => 85
        def quality(percentage)
          manipulate! do |img|
            img.quality(percentage)
            img = yield(img) if block_given?
            img
          end
        end

        def extract_content_type
          model.data_content_type = Utils::ContentTypeDetector.new(file.path).detect
        end

        def extract_size
          model.data_file_size = file.size
        end

        def extract_dimensions
          if model.image? && model.has_dimensions?
            model.width = magick[:width]
            model.height = magick[:height]
          end
        end

        def magick
          @magick ||= ::MiniMagick::Image.new(current_path)
        end
      end
    end
  end
end
