# frozen_string_literal: true
module Ckeditor
  class Picture < Ckeditor::Asset
    include CkeditorPictureUploader.attachment(:data)

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
