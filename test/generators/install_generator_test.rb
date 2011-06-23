require "test_helper"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Ckeditor::Generators::InstallGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  #test "Assert all files are properly created" do
  #  run_generator
  #  assert_file "config/initializers/ckeditor.rb"
  #  assert_file "tmp/ckeditor_#{Ckeditor::Version::EDITOR}.tar.gz"
  #end
end
