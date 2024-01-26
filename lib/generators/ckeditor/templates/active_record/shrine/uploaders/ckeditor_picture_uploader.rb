# frozen_string_literal: true

class CkeditorPictureUploader < Shrine
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :derivatives, versions_compatibility: true

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/gif image/png]
    validate_max_size 2.megabytes
  end

  Attacher.derivatives_processor do |original|
    magick = SHRINE_PICTURE_PROCESSOR.source(original)
    {
      content: magick.resize_to_limit!(800, 800),
      thumb:   magick.resize_to_limit!(118, 100),
    }
  end
end
