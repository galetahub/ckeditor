# frozen_string_literal: true

module Ckeditor
  module Backend
    module Paperclip
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def self.extended(base)
          base.class_eval do
            delegate :url, :path, :styles, :content_type, to: :data
          end
        end
      end

      module InstanceMethods
        def geometry
          @geometry ||= ::Paperclip::Geometry.from_file(file)
        end

        protected

        def file
          @file ||= data.respond_to?(:queued_for_write) ? data.queued_for_write[:original] : data.to_file
        end
      end
    end
  end
end
