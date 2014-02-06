module Ckeditor
  module Orm
    module Base
      module AssetBase
        module InstanceMethods
          def filename
            data_file_name
          end

          def size
            data_file_size
          end

          def has_dimensions?
            respond_to?(:width) && respond_to?(:height)
          end

          def image?
            Ckeditor::IMAGE_TYPES.include?(data_content_type)
          end

          def format_created_at
            self.created_at.strftime("%d.%m.%Y")
          end

          def url_content
            url
          end

          def url_thumb
            url(:thumb)
          end

          def as_json_methods
            [:url_content, :url_thumb, :size, :filename, :format_created_at]
          end

          def as_json(options = nil)
            options = {
              :methods => as_json_methods,
              :root => "asset"
            }.merge(options || {})

            super options
          end
        end
      end
    end
  end
end
