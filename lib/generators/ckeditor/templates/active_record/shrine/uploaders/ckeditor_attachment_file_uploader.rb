# frozen_string_literal: true

class CkeditorAttachmentFileUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 100.megabytes
  end
end
