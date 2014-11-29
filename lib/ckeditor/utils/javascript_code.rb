# encoding: utf-8

module Ckeditor
  module Utils
    class JavascriptCode < String
      def as_json(options = nil) self end #:nodoc:
      def encode_json(encoder) self end #:nodoc:
    end
  end
end