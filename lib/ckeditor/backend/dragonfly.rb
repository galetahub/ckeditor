module Ckeditor
  module Backend
    module Dragonfly
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end
      
      module ClassMethods
        def attachment_file_types
          @attachment_file_types ||= Ckeditor.attachment_file_types.map(&:to_sym).tap do |formats|
            # This is not ideal but Dragonfly doesn't return double
            # extensions. Having said that, the other backends
            # currently don't use attachment_file_types at all.
            [ :bz2, :gz, :lzma, :xz ].each do |f|
              formats << f if formats.include?("tar.#{f}".to_sym)
            end
          end
        end

        def image_file_types
          @image_file_types ||= Ckeditor.image_file_types.map(&:to_sym)
        end
      end
      
      module InstanceMethods
        delegate :url, :path, :size, :image?, :width, :height, :to => :data

        alias_attribute :data_file_name, :data_name
        alias_attribute :data_content_type, :data_mime_type
        alias_attribute :data_file_size, :data_size

        private

        def url_thumb_options
          if data.basename.present?
            { :basename => "thumb_#{data.basename}" }
          else
            {}
          end
        end
      end
    end
  end
end
