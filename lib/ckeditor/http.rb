# encoding: utf-8
require 'digest/sha1'
require 'mime/types'

module Ckeditor
  module Http
    # Create tempfile from hash
    class UploadedFile
      attr_accessor :original_filename, :content_type, :tempfile, :headers

      def initialize(hash)
        @original_filename = hash[:filename]
        @content_type      = hash[:type]
        @headers           = hash[:head]
        @tempfile          = hash[:tempfile]
        raise(ArgumentError, ':tempfile is required') unless @tempfile
      end

      def open
        @tempfile.open
      end

      def path
        @tempfile.path
      end

      def read(*args)
        @tempfile.read(*args)
      end

      def rewind
        @tempfile.rewind
      end

      def size
        @tempfile.size
      end
    end
    
    # Usage (paperclip example)
    # @asset.data = QqFile.new(params[:qqfile], request)
    class QqFile < ::Tempfile

      def initialize(filename, request, tmpdir = Dir::tmpdir)
        @original_filename  = filename
        @request = request
        
        super Digest::SHA1.hexdigest(filename), tmpdir
        binmode
        fetch
      end
     
      def fetch
        self.write(body)
        self.rewind
        self
      end
     
      def original_filename
        @original_filename
      end
     
      def content_type
        types = MIME::Types.type_for(original_filename)
        types.empty? ? @request.content_type : types.first.to_s
      end
      
      def body
        if @request.raw_post.respond_to?(:force_encoding)
          @request.raw_post.force_encoding("UTF-8")
        else
          @request.raw_post
        end
      end
    end
    
    # Convert nested Hash to HashWithIndifferentAccess and replace
    # file upload hash with UploadedFile objects
    def self.normalize_param(*args)
      value = args.first
      if Hash === value && value.has_key?(:tempfile)
        UploadedFile.new(value)
      elsif value.is_a?(String)
        QqFile.new(*args)
      else
        value
      end
    end
  end
end
