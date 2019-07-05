# frozen_string_literal: true

module Ckeditor
  module Backend
    module ActiveStorage
      def self.included(base)
        base.send(:include, Rails.application.routes.url_helpers)
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def self.extended(base)
          base.class_eval do

          end
        end
      end

      module InstanceMethods
        def url
          rails_blob_path(self.data, only_path: true)
        end

        def path
          rails_blob_path(self.data, only_path: true)
        end

        def styles
        end

        def content_type
          self.data.content_type
        end
      end
    end
  end
end
