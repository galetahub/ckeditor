# Ckeditor

CKEditor is a ready-for-use HTML text editor designed to simplify web content creation. It's a WYSIWYG editor that brings common word processor features directly to your web pages. Enhance your website experience with our community maintained editor.
[ckeditor.com](http://ckeditor.com/)

## Features

* Ckeditor version 4.3.4 (full)
* Rails 4 integration
* Files browser
* HTML5 files uploader
* Hooks for formtastic and simple_form forms generators
* Integrated with authorization framework CanCan and Pundit

## Installation

For basic usage just include ckeditor gem:

```
gem 'ckeditor'
```
#### Using with ruby 1.8.7

For usage with ruby 1.8.7 you need to specify gem version:

```
gem 'ckeditor', '4.0.4'
```

For files uploading support you need generage models for file storage.
Currently supported next backends:

* ActiveRecord (paperclip, carrierwave, dragonfly)
* Mongoid (paperclip, carrierwave, dragonfly)

### How generate models for store uploading files

#### ActiveRecord + paperclip

For active_record orm is used paperclip gem (it's by default).

```
gem 'paperclip'

rails generate ckeditor:install --orm=active_record --backend=paperclip
```

#### ActiveRecord + carrierwave

```
gem 'carrierwave'
gem 'mini_magick'

rails generate ckeditor:install --orm=active_record --backend=carrierwave
```

#### Mongoid + paperclip

```
gem 'mongoid-paperclip', :require => 'mongoid_paperclip'

rails generate ckeditor:install --orm=mongoid --backend=paperclip
```

#### Mongoid + carrierwave

```
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'

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
mount Ckeditor::Engine => '/ckeditor'
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
  <%= form.cktext_area :notes, :class => 'someclass', :ckeditor => {:language => 'uk'} %>
  ...
  <%= form.cktext_area :content, :value => 'Default value', :id => 'sometext' %>
  ...
  <%= cktext_area :page, :info, :cols => 40, :ckeditor => {:uiColor => '#AADC6E', :toolbar => 'mini'} %>
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
to determine path to assets. Therefore we have to create a rake task thats copies the original assets and creates a non-digest version of it. Some example of such rake task is:

```ruby
namespace :ckeditor do
  desc 'Create nondigest versions of some ckeditor assets (e.g. moono skin png)'
  task :create_nondigest_assets do
    fingerprint = /\-[0-9a-f]{32}\./
    for file in Dir['public/assets/ckeditor/contents-*.css', 'public/assets/ckeditor/skins/moono/*.png']
      next unless file =~ fingerprint
      nondigest = file.sub fingerprint, '.' # contents-0d8ffa186a00f5063461bc0ba0d96087.css => contents.css
      FileUtils.cp file, nondigest, verbose: true
    end
  end
end

# auto run ckeditor:create_nondigest_assets after assets:precompile
Rake::Task['assets:precompile'].enhance do
  Rake::Task['ckeditor:create_nondigest_assets'].invoke
end
```
This also works on heroku. Even after restarting dynos running on a cedar stack, the assets will remain.

You can include this rake task in a capistrano task (if you are deploying via capistrano):

```ruby
desc 'copy ckeditor nondigest assets'
task :copy_nondigest_assets, roles: :app do
  run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} ckeditor:create_nondigest_assets"
end
after 'deploy:assets:precompile', 'copy_nondigest_assets'
```

Periodically check your error monitoring tool, if you see some part of ckeditor try to load
unexisting non-digest asset - if so just add it in the ckeditor rake task.

Also you can use gem [non-stupid-digest-assets](https://rubygems.org/gems/non-stupid-digest-assets), which do the same work.

To reduce the asset precompilation time, you can limit plugins and/or languages to those you need:

```ruby
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  config.assets_languages = ['en', 'fr']
  config.assets_plugins = ['image', 'smiley']
end
```

### AJAX

jQuery sample:

```html
<script type='text/javascript' charset='UTF-8'>
  $(document).ready(function(){
    $('form[data-remote]').bind('ajax:before', function(){
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

### Pundit integration

Just like CanCan, you can write this code in your config/initializers/ckeditor.rb file

```ruby
Ckeditor.setup do |config|
  config.authorize_with :pundit
end
```

And then, generate the policy files for model **Picture** and **AttachmentFile**

```
$ rails g ckeditor:pundit_policy
```
By this command, you will got two files:
> app/policies/ckeditor/picture_policy.rb
app/policies/ckeditor/attachment_file_policy.rb

By default, only the user that logged in can access the models(with action *index* and *create*), and only the owner of the asset can **destroy** the resource.

You can simply customize these two policy files as you like.

## I18n

```yml
en:
  ckeditor:
    page_title: 'CKEditor Files Manager'
    confirm_delete: 'Delete file?'
    buttons:
      cancel: 'Cancel'
      upload: 'Upload'
      delete: 'Delete'
      next: 'Next'
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
