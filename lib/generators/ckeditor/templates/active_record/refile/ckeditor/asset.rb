# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Backend::Refile
  include Ckeditor::Orm::ActiveRecord::AssetBase
end
