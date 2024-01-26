# frozen_string_literal: true

class CkeditorPictureUploader < Shrine
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
