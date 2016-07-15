# encoding: utf-8
require 'cocaine'

module Ckeditor
  module Utils
    class ContentTypeDetector
      EMPTY_CONTENT_TYPE = 'inode/x-empty'.freeze
      DEFAULT_CONTENT_TYPE = 'application/octet-stream'.freeze

      def initialize(file_path)
        @file_path = file_path
      end

      # content type detection strategy:
      #
      # 1. empty file: returns 'inode/x-empty'
      # 2. nonempty file: if the file is not empty then returns the content type using file command
      # 3. invalid file: file command raises error and returns 'application/octet-stream'

      def detect
        empty_file? ? EMPTY_CONTENT_TYPE : content_type_from_file_command
      end

      private

      def empty_file?
        return true if @file_path.blank?
        File.exist?(@file_path) && File.size(@file_path).zero?
      end

      def content_type_from_file_command
        Cocaine::CommandLine.new('file', '-b --mime-type :file').run(file: @file_path).strip
      rescue Cocaine::CommandLineError
        DEFAULT_CONTENT_TYPE
      end
    end
  end
end
