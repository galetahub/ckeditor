require 'fileutils'

namespace "ckeditor" do
  desc "Create nondigest versions of all ckeditor digest assets"
  task "nondigest" => [:environment] do
    fingerprint = /\-[0-9a-f]{32,64}\./
    path        = File.join Rails.root.to_s, "public", Ckeditor.base_path, "**/*"
    files       = Dir[path]

    for file in files
      next unless file =~ fingerprint
      nondigest = file.sub fingerprint, '.'

      if !File.exist?(nondigest) or File.mtime(file) > File.mtime(nondigest)
        FileUtils.cp file, nondigest, verbose: true, preserve: true
      end
    end
  end
end

# Based on rake task from asset_sync gem
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["ckeditor:nondigest"].invoke if defined?(Ckeditor) && Ckeditor.run_on_precompile?
  end
end
