# frozen_string_literal: true

class CkeditorAttachmentUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 5 * 1024 * 1024 # file size must not be greater than 5 MB
    validate_min_size 1024 # file size must not be less than 1 KB
  end
end
