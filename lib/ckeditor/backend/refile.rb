module Ckeditor
  module Backend
    module Refile
      extend ActiveSupport::Concern

      included do
        validates :data, presence: true
        delegate :rewind, :download, :to_io, :exists?, :delete, :close, :eof?, :read, to: :data
        alias_attribute :data_file_name, :data_filename
        alias_attribute :data_file_size, :data_size
      end

      class_methods do
        def attachment_file_types
          @attachment_file_types ||= Ckeditor.attachment_file_types.map(&:to_s)
        end

        def image_file_types
          @image_file_types ||= Ckeditor.image_file_types.map(&:to_s)
        end
      end

      def url(*attrs)
        ::Refile.attachment_url(self, :data, *attrs)
      end

      def magick
        @magick ||= MiniMagick::Image.open(model.to_io)
      end

      def extract_dimensions
        if model.image? && model.has_dimensions?
          model.width = magick.width
          model.height = magick.height
        end
      end
    end
  end
end
