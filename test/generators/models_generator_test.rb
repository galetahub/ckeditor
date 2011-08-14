require "test_helper"

class ModelsGeneratorTest < Rails::Generators::TestCase
  tests Ckeditor::Generators::ModelsGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

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

  test "models for mongoid orm" do
    run_generator %w(--orm=mongoid)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_no_migration "db/migrate/create_ckeditor_assets.rb"
  end
end
