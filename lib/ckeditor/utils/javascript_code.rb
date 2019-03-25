# frozen_string_literal: true

module Ckeditor
  module Utils
    class JavascriptCode < String
      def as_json(_options = nil)
        self
      end

      def encode_json(_encoder)
        self
      end
    end
  end
end
