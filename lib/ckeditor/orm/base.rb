module Ckeditor
  module Orm
    module Base
      module AssetBase
        module InstanceMethods
          def filename
            data_file_name
          end
          
          def has_dimensions?
            respond_to?(:width) && respond_to?(:height)
          end
          
          def image?
            Ckeditor::IMAGE_TYPES.include?(data_content_type)
          end
          
          def geometry
            @geometry ||= Paperclip::Geometry.from_file(data.to_file)
          end

          def format_created_at
            I18n.l(created_at, :format => "%d.%m.%Y")
          end

          def url_content
            url
          end

          def url_thumb
            url(:thumb)
          end

          def as_json(options = nil)
            options = {
              :methods => [:url_content, :url_thumb, :size, :filename, :format_created_at],
              :root => "asset"
            }.merge(options || {})

            super options
          end

          protected

          def parameterize_filename
            unless data_file_name.blank?
              filename = Ckeditor::Utils.parameterize_filename(data_file_name)
              self.data.instance_write(:file_name, filename)
            end
          end

          def read_dimensions
            if image? && has_dimensions?
              self.width = geometry.width
              self.height = geometry.height
            end
          end

          # Extract content_type from filename using mime/types gem
          def extract_content_type
            if data_content_type == "application/octet-stream" && !data_file_name.blank?
              content_types = MIME::Types.type_for(data_file_name)
              self.data_content_type = content_types.first.to_s unless content_types.empty?
            end
          end
        end
      end
    end
  end
end
