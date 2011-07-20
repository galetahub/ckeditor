require "test_helper"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Ckeditor::Generators::InstallGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator %w(--orm=active_record)

    assert_file "config/initializers/ckeditor.rb", /require "ckeditor\/orm\/active_record"/

    assert_file "tmp/ckeditor_#{Ckeditor::Version::EDITOR}.tar.gz"

    ["rails.js", "jquery.js", "fileuploader.js", "jquery.tmpl.js"].each do |file|
      assert_file "public/javascripts/ckeditor/filebrowser/javascripts/#{file}"
    end
  end

  test "Assert configurator is valid for mongoid" do
    run_generator %w(--orm=mongoid)

    assert_file "config/initializers/ckeditor.rb", /require "ckeditor\/orm\/mongoid"/
  end
end
