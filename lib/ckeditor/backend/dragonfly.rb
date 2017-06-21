module Ckeditor
  module Backend
    module Dragonfly
      FORMATS = %w[bz2 gz lzma xz].freeze

      def self.included(base)
        base.send(:extend, ::Dragonfly::Model)
        base.send(:extend, ::Dragonfly::Model::Validations)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def attachment_file_types
          @attachment_file_types ||= Ckeditor.attachment_file_types.map(&:to_s).tap do |formats|
            # This is not ideal but Dragonfly doesn't return double
            # extensions. Having said that, the other backends
            # currently don't use attachment_file_types at all.
            FORMATS.each do |f|
              formats << f if formats.include?("tar.#{f}")
            end
          end
        end

        def image_file_types
          @image_file_types ||= Ckeditor.image_file_types.map(&:to_s)
        end
      end

      module InstanceMethods
        delegate :url, :path, :image?, :width, :height, to: :data

        alias_attribute :data_file_name, :data_name
        alias_attribute :data_content_type, :"data.mime_type"
        alias_attribute :data_file_size, :data_size

        private

        def url_thumb_options
          if data.basename.present?
            { basename: "thumb_#{data.basename}" }
          else
            {}
          end
        end
      end
    end
  end
end
