require "test_helper"
require "fileutils"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Ckeditor::Generators::InstallGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  setup do
    dir = File.expand_path("../../", __FILE__)

    FileUtils.mkdir_p File.join(dir, 'tmp/config')
    FileUtils.cp File.join(dir, 'support/routes.txt'), File.join(dir, 'tmp/config/routes.rb')
  end

  test "Assert all files are properly created" do
    run_generator %w(--orm=active_record)

    assert_file "config/initializers/ckeditor.rb", /require 'ckeditor\/orm\/active_record'/
    assert_file "config/routes.rb", /mount\sCkeditor::Engine\s=\>\s\'\/ckeditor\'/
  end

  test "Assert configurator is valid for mongoid" do
    run_generator %w(--orm=mongoid)

    assert_file "config/initializers/ckeditor.rb", /require 'ckeditor\/orm\/mongoid'/
  end

  test "models and migration for active_record orm via paperclip" do
    run_generator %w(--orm=active_record --backend=paperclip)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_migration "db/migrate/create_ckeditor_assets.rb" do |migration|
      assert_class_method :up, migration do |up|
        assert_match /create_table/, up
      end
    end
  end

  test "models and migration for active_record orm via carrierwave" do
    run_generator %w(--orm=active_record --backend=carrierwave)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_file "app/uploaders/ckeditor_attachment_file_uploader.rb"
    assert_file "app/uploaders/ckeditor_picture_uploader.rb"

    assert_migration "db/migrate/create_ckeditor_assets.rb" do |migration|
      assert_class_method :up, migration do |up|
        assert_match /create_table/, up
      end
    end
  end

  test "models and migration for active_record orm via refile" do
    run_generator %w(--orm=active_record --backend=refile)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_migration "db/migrate/create_ckeditor_assets.rb" do |migration|
      assert_class_method :up, migration do |up|
        assert_match /create_table/, up
      end
    end
  end

  test "models and migration for active_record orm via dragonfly" do
    run_generator %w(--orm=active_record --backend=dragonfly)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_migration "db/migrate/create_ckeditor_assets.rb" do |migration|
      assert_class_method :up, migration do |up|
        assert_match /create_table/, up
        assert_match /data_uid/, up
      end
    end
  end

  test "models for mongoid orm via paperclip" do
    run_generator %w(--orm=mongoid --backend=paperclip)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_no_migration "db/migrate/create_ckeditor_assets.rb"
  end

  test "models for mongoid orm via carrierwave" do
    run_generator %w(--orm=mongoid --backend=carrierwave)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_file "app/uploaders/ckeditor_attachment_file_uploader.rb"
    assert_file "app/uploaders/ckeditor_picture_uploader.rb"

    assert_no_migration "db/migrate/create_ckeditor_assets.rb"
  end
end
