module Ckeditor::ApplicationHelper
  def assets_pipeline_enabled?
    if Gem::Version.new(::Rails.version.to_s) >= Gem::Version.new('4.0.0')
      defined?(Sprockets::Rails)
    elsif Gem::Version.new(::Rails.version.to_s) >= Gem::Version.new('3.0.0')
      Rails.application.config.assets.enabled
    else
      false
    end
  end
end