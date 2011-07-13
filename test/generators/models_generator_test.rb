require "test_helper"

class ModelsGeneratorTest < Rails::Generators::TestCase
  tests Ckeditor::Generators::ModelsGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "models and migration for active_record orm" do
    run_generator %w(--orm=active_record)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"

    assert_migration "db/migrate/create_ckeditor_assets.rb" do |migration|
      assert_class_method :up, migration do |up|
        assert_match /create_table/, up
      end
    end
  end

  test "models and migration for mongoid orm" do
    run_generator %w(--orm=mongoid)

    assert_file "app/models/ckeditor/asset.rb"
    assert_file "app/models/ckeditor/picture.rb"
    assert_file "app/models/ckeditor/attachment_file.rb"
  end
end
