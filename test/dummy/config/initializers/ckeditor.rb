dir = File.join(Rails.root, "..", "..", "lib", "generators", "ckeditor", "templates")

# Load the CKEditor initializer from the codebase.
initializer = ERB.new(File.read(File.join(dir, "ckeditor.rb")))
options = { :orm => CKEDITOR_ORM }
eval initializer.result(binding)

# Also load the specific initializer for the selected backend.
initializer = File.join(dir, "base", CKEDITOR_BACKEND.to_s, "initializer.rb")
require initializer if File.exist?(initializer)
