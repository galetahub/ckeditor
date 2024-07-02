# frozen_string_literal: true

module Ckeditor
  module Backend
    module Shrine
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def data=(value)
          self.attachment_data = value
        end

        def url
          attachment.url
        end

        def data_file_name
          datasource['filename']
        end

        def data_file_size
          datasource['size']
        end

        def datasource
          @datasource ||= attachment&.metadata || {}
        end
      end
    end
  end
end
