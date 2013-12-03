# Ckeditor

CKEditor is a ready-for-use HTML text editor designed to simplify web content creation. It's a WYSIWYG editor that brings common word processor features directly to your web pages. Enhance your website experience with our community maintained editor.
[ckeditor.com](http://ckeditor.com/)

## Features

* Ckeditor version 4.3 (full)
* Rails 4 integration
* Files browser
* HTML5 files uploader
* Hooks for formtastic and simple_form forms generators

## Installation

For basic usage just include ckeditor gem:

```
gem "ckeditor"
```

For files uploading support you need generage models for file storage.
Currently supported next backends:

* ActiveRecord (paperclip, carrierwave, dragonfly)
* Mongoid (paperclip, carrierwave, dragonfly)

### How generate models for store uploading files

#### ActiveRecord + paperclip

For active_record orm is used paperclip gem (it's by default).

```
gem "paperclip"

rails generate ckeditor:install --orm=active_record --backend=paperclip
```

#### ActiveRecord + carrierwave

```
gem "carrierwave"
gem "mini_magick"

rails generate ckeditor:install --orm=active_record --backend=carrierwave
```

#### Mongoid + paperclip

```
gem 'mongoid-paperclip', :require => 'mongoid_paperclip'

rails generate ckeditor:install --orm=mongoid --backend=paperclip
```

#### Mongoid + carrierwave

```
gem "carrierwave-mongoid", :require => 'carrierwave/mongoid'
gem "mini_magick"

rails generate ckeditor:install --orm=mongoid --backend=carrierwave
```

#### Load generated models

All ckeditor models will be generated into app/models/ckeditor folder.
Autoload ckeditor models folder (application.rb):

```ruby
config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
```

Mount engine in your routes (config/routes.rb):

```ruby
mount Ckeditor::Engine => "/ckeditor"
```

## Usage

Include ckeditor javascripts rails 3.2 (application.js):

```
//= require ckeditor/init
```

Form helpers:

```erb
<%= form_for @page do |form| -%>
  ...
  <%= form.cktext_area :notes, :class => "someclass", :ckeditor => {:language => "uk"} %>
  ...
  <%= form.cktext_area :content, :value => "Default value", :id => "sometext" %>
  ...
  <%= cktext_area :page, :info, :cols => 40, :ckeditor => {:uiColor => "#AADC6E", :toolbar => "mini"} %>
  ...
<% end -%>
```

All ckeditor options [here](http://docs.ckeditor.com/#!/api/CKEDITOR.config)

In order to configure the ckeditor default options, create files:

```
app/assets/javascripts/ckeditor/config.js

app/assets/javascripts/ckeditor/contents.css
```

### Usage with Rails 4 assets

In order to use rails 4 assets with digest in production environment you need some preparing.

First, you need to include in `application.js` **before** `ckeditor/init`

```
//= require ckeditor/override
```

It forces ckeditor core to respect digested assets.

Next you need to check, that some non-core plugins and skins don't use core ckeditor functions
to determine path to assets. For the latter we must determine task to copy non-digest assets in
assets folder. Some example of such rake task is:

```ruby
namespace :ckeditor do
  def copy_assets(regexp)
    Rails.application.assets.each_logical_path(regexp) do |name, path|
      asset = Rails.root.join('public', 'assets', name)
      p "Copy #{path} to #{asset}"
      FileUtils.mkdir_p(File.dirname(asset))
      FileUtils.cp path, asset
    end
  end

  desc 'Copy ckeditor assets, that cant be used with digest'
  task copy_nondigest_assets: :environment do
    copy_assets /ckeditor\/contents.css/
    copy_assets /ckeditor\/skins\/moono\/.+png/
  end
end
```

You can include this rake task in capistrano task (if you are deploying via capistrano):

```ruby
desc 'copy ckeditor nondigest assets'
task :copy_nondigest_assets, roles: :app do
  run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} ckeditor:copy_nondigest_assets"
end
after 'deploy:assets:precompile', 'copy_nondigest_assets'
```

Periodically check your error monitoring tool, if you see some part of ckeditor try to load
unexisted non-digest asset - just add it in ckeditor rake task.

### AJAX

jQuery sample:

```html
<script type='text/javascript' charset='UTF-8'>
  $(document).ready(function(){
    $('form[data-remote]').bind("ajax:before", function(){
      for (instance in CKEDITOR.instances){
        CKEDITOR.instances[instance].updateElement();
      }
    });
  });
</script>
```

### Formtastic integration

```erb
<%= form.input :content, :as => :ckeditor %>
<%= form.input :content, :as => :ckeditor, :input_html => { :ckeditor => { :height => 400 } } %>
```

### SimpleForm integration

```erb
<%= form.input :content, :as => :ckeditor, :input_html => { :ckeditor => {:toolbar => 'Full'} } %>
```

### CanCan integration

To use cancan with Ckeditor, add this to an initializer.

```ruby
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  config.authorize_with :cancan
end
```

At this point, all authorization will fail and no one will be able to access the filebrowser pages.
To grant access, add this to Ability#initialize

```ruby
# Always performed
can :access, :ckeditor   # needed to access Ckeditor filebrowser

# Performed checks for actions:
can [:read, :create, :destroy], Ckeditor::Picture
can [:read, :create, :destroy], Ckeditor::AttachmentFile
```

## I18n

```yml
en:
  ckeditor:
    page_title: "CKEditor Files Manager"
    confirm_delete: "Delete file?"
    buttons:
      cancel: "Cancel"
      upload: "Upload"
      delete: "Delete"
```

## Tests

```bash
$> rake test
$> rake test CKEDITOR_ORM=mongoid
$> rake test CKEDITOR_BACKEND=carrierwave

$> rake test:controllers
$> rake test:generators
$> rake test:integration
$> rake test:models
```

This project rocks and uses MIT-LICENSE.
