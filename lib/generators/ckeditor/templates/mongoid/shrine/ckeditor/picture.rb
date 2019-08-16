# frozen_string_literal: true
module Ckeditor
  class PictureUploader < Shrine
    plugin :determine_mime_type
    plugin :validation_helpers
    plugin :processing
    plugin :versions

    Attacher.validate do
      validate_mime_type_inclusion %w[image/jpeg image/gif image/png]
      validate_max_size 2.megabytes
    end

    process(:store) do |io, _context|
      # return the hash of processed files
      {}.tap do |versions|
        io.download do |original|
          pipeline = SHRINE_PICTURE_PROCESSOR.source(original)

          versions[:content] = pipeline.resize_to_limit!(800, 800)
          versions[:thumb] = pipeline.resize_to_limit!(118, 100)
        end
      end
    end
  end

  class Picture < Ckeditor::Asset
    include PictureUploader.attachment(:data)

    validates :data, presence: true

    def url_content
      data_url(:content)
    end

    def url_thumb
      data_url(:thumb)
    end

    def path
      data[:thumb].storage.path(data[:thumb].id)
    end

    def datasource
      @datasource ||= HashWithIndifferentAccess
                      .new(data)
                      .fetch(:thumb, OpenStruct.new(metadata: {}))
                      .metadata
    end
  end
end
