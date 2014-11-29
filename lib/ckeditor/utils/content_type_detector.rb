# encoding: utf-8
require 'cocaine'

module Ckeditor
  module Utils
    class ContentTypeDetector
      EMPTY_CONTENT_TYPE = 'inode/x-empty'
      DEFAULT_CONTENT_TYPE = 'application/octet-stream'

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
        File.exists?(@file_path) && File.size(@file_path) == 0
      end

      def content_type_from_file_command
        type = begin
          Cocaine::CommandLine.new('file', '-b --mime-type :file').run(file: @file_path)
        rescue Cocaine::CommandLineError => e
          # TODO: log command failure
          DEFAULT_CONTENT_TYPE
        end.strip
      end
    end
  end
end