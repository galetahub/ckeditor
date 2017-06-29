# Ckeditor

[![Build Status](https://semaphoreci.com/api/v1/igor-galeta/ckeditor/branches/master/shields_badge.svg)](https://semaphoreci.com/igor-galeta/ckeditor)
[![Code Climate](https://codeclimate.com/github/galetahub/ckeditor/badges/gpa.svg)](https://codeclimate.com/github/galetahub/ckeditor)

CKEditor is a WYSIWYG text editor designed to simplify web content creation. It brings common word processing features directly to your web pages. Enhance your website experience with our community maintained editor.
[ckeditor.com](http://ckeditor.com/)

## Features

* CKEditor version 4.7.1 full (28 Jun 2017)
* Rails 5.0.x, 5.1.x, 4.2.x integration
* Files browser
* HTML5 file uploader
* Hooks for formtastic and simple_form forms generators
* Integrated with authorization framework CanCan and Pundit

## Installation

For basic usage just include the ckeditor gem:

```
gem 'ckeditor'
```

or if you'd like to use the latest version from Github:

```
gem 'ckeditor', github: 'galetahub/ckeditor'
```

The last version works with Rails 3.2.x is 4.1.3

```ruby
gem 'ckeditor', '4.1.3'
```

For file upload support, you must generate the necessary file storage models.
The currently supported backends are:

* ActiveRecord (paperclip, carrierwave, dragonfly, refile)
* Mongoid (paperclip, carrierwave, dragonfly)

### How to generate models to store uploaded files

#### ActiveRecord + paperclip

To use the active_record orm with paperclip (i.e. the default settings):

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

#### ActiveRecord + refile

```
gem 'refile', require: "refile/rails"
gem 'refile-mini_magick'

rails generate ckeditor:install --orm=active_record --backend=refile
```

#### ActiveRecord + dragonfly

Requires Dragonfly 1.0 or greater.

```
gem 'dragonfly'

rails generate ckeditor:install --orm=active_record --backend=dragonfly
```

#### Mongoid + paperclip

```
gem 'mongoid-paperclip', require: 'mongoid_paperclip'

rails generate ckeditor:install --orm=mongoid --backend=paperclip
```

#### Mongoid + carrierwave

```
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
gem 'mini_magick'

rails generate ckeditor:install --orm=mongoid --backend=carrierwave
```

#### Load generated models

All ckeditor models will be generated in the app/models/ckeditor directory.
Models are autoloaded in Rails 4. For earlier Rails versions, you need to add them to the autoload path (in application.rb):

```ruby
config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
```

Mount the Ckeditor::Engine in your routes (config/routes.rb):

```ruby
mount Ckeditor::Engine => '/ckeditor'
```

## Usage

### Load editor from gem vendor

Include ckeditor javascripts in your `app/assets/javascripts/application.js`:

```
//= require ckeditor/init
```

### Load editor via CKEditor CDN

Setup editor version to load (more info here http://cdn.ckeditor.com/)

```ruby
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  # //cdn.ckeditor.com/<version.number>/<distribution>/ckeditor.js
  config.cdn_url = "//cdn.ckeditor.com/4.6.1/basic/ckeditor.js"
end
```

In view template include ckeditor CDN:

```slim
= javascript_include_tag Ckeditor.cdn_url
```

Precompile ckeditor/config.js:

```ruby
# in config/initializers/assets.rb

Rails.application.config.assets.precompile += %w(ckeditor/config.js)
```

### Form helpers

```slim
= form_for @page do |form|
  = form.cktext_area :notes, class: 'someclass', ckeditor: { language: 'uk'}
  = form.cktext_area :content, value: 'Default value', id: 'sometext'
  = cktext_area :page, :info, cols: 40, ckeditor: { uiColor: '#AADC6E', toolbar: 'mini' }
```

### Customize ckeditor

All ckeditor options can be found [here](http://docs.ckeditor.com/#!/api/CKEDITOR.config)

In order to configure the ckeditor default options, create the following files:

```
app/assets/javascripts/ckeditor/config.js

app/assets/javascripts/ckeditor/contents.css
```

#### Custom toolbars example

Adding a custom toolbar:

```javascript
# in app/assets/javascripts/ckeditor/config.js

CKEDITOR.editorConfig = function (config) {
  // ... other configuration ...

  config.toolbar_mini = [
    ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
  ];
  config.toolbar = "simple";

  // ... rest of the original config.js  ...
}
```

When overriding the default `config.js` file, you must set all configuration options yourself as the bundled `config.js` will not be loaded. To see the default configuration, run `bundle open ckeditor`, copy `app/assets/javascripts/ckeditor/config.js` into your project and customize it to your needs.

### Deployment (only if you use ckeditor from gem vendor)

For Rails 4 and 5, add the following to `config/initializers/assets.rb`:

```ruby
Rails.application.config.assets.precompile += %w( ckeditor/* )
```

As of version 4.1.0, non-digested assets of Ckeditor will simply be copied after digested assets were compiled.
For older versions, use gem [non-stupid-digest-assets](https://rubygems.org/gems/non-stupid-digest-assets), to copy non digest assets.

To reduce the asset precompilation time, you can limit plugins and/or languages to those you need:

```ruby
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  config.assets_languages = ['en', 'fr']
  config.assets_plugins = ['image', 'smiley']
end
```

Note that you have to list your plugins, including all their dependencies.

### Include customized CKEDITOR_BASEPATH setting

Add your app/assets/javascripts/ckeditor/basepath.js.erb like

```erb
<%
  base_path = ''
  if ENV['PROJECT'] =~ /editor/i
    base_path << "/#{Rails.root.basename.to_s}/"
  end
  base_path << Rails.application.config.assets.prefix
  base_path << '/ckeditor/'
%>
var CKEDITOR_BASEPATH = '<%= base_path %>';
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

```slim
= form.input :content, as: :ckeditor
= form.input :content, as: :ckeditor, input_html: { ckeditor: { height: 400 } }
```

### SimpleForm integration

```slim
= form.input :content, as: :ckeditor, input_html: { ckeditor: { toolbar: 'Full' } }
```

### Turbolink integration
Create a file app/assets/javascripts/init_ckeditor.coffee

```coffee
ready = ->
  $('.ckeditor').each ->
    CKEDITOR.replace $(this).attr('id')

$(document).ready(ready)
$(document).on('page:load', ready)
```
Make sure the file is loaded from your app/assets/javascripts/application.js

### CanCan integration

To use cancan with Ckeditor, add this to an initializer:

```ruby
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  config.authorize_with :cancan
end
```

At this point, all authorization will fail and no one will be able to access the filebrowser pages.
To grant access, add this to Ability#initialize:

```ruby
# Always performed
can :access, :ckeditor   # needed to access Ckeditor filebrowser

# Performed checks for actions:
can [:read, :create, :destroy], Ckeditor::Picture
can [:read, :create, :destroy], Ckeditor::AttachmentFile
```

### Pundit integration

Just like CanCan, you can write this code in your config/initializers/ckeditor.rb file:

```ruby
Ckeditor.setup do |config|
  config.authorize_with :pundit
end
```

Then, generate the policy files for model **Picture** and **AttachmentFile**

```
$ rails g ckeditor:pundit_policy
```
By this command, you will got two files:
> app/policies/ckeditor/picture_policy.rb
app/policies/ckeditor/attachment_file_policy.rb

By default, only the user that logged in can access the models (with actions *index* and *create*) and only the owner of the asset can **destroy** the resource.

You can customize these two policy files as you like.

## Engine configuration
 * To override the default CKEditor routes create a [config.js](https://github.com/galetahub/ckeditor/blob/master/app/assets/javascripts/ckeditor/config.js) file within the host application at `app/assets/javascripts/ckeditor/config.js`
 * To override the default parent controller
```
# in config/initializers/ckeditor.rb

Ckeditor.setup do |config|
  config.parent_controller = 'MyController'
end
```

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
$> rake test CKEDITOR_BACKEND=paperclip
$> rake test CKEDITOR_BACKEND=carrierwave
$> rake test CKEDITOR_BACKEND=refile
$> rake test CKEDITOR_BACKEND=dragonfly
$> rake test CKEDITOR_ORM=mongoid

$> rake test:controllers
$> rake test:generators
$> rake test:integration
$> rake test:models
```

This project rocks and uses the MIT-LICENSE.
