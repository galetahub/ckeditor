# Ckeditor changelog

## Ckeditor 5.1.3

  * Rename app/assets/config/manifest.js to app/assets/config/ckeditor_manifest.js (issue #938)
  * Set config.versionCheck = false; by default to hide security notification (issue #933)

## Ckeditor 5.1.2

  * Upgrade CKEditor to 4.22.1 version
  * Bump ruby version to 2.7.6
  * Temporarily turn off paperclip gem support

## Ckeditor 5.1.1 (12-1-2021)

  * Add hook for action_policy support
  * Update gems to fix potential security vulnerabilities

## Ckeditor 5.1.0 (06-03-2020)

  * Add Active Storage backend support
  * Add Shrine backend support

## Ckeditor 5.0.0

  * CDN version only (breaking changes)

    Previously you could use a bundled version of the editor by adding `//= require ckeditor/init` to your application.js. From 5.0 this is no longer available.
  * Upgrade rails to 5.2.x
  * Remove refile support due no activity since 2015
  * Remove auto-detect content-type (`extract_content_type`) and image dimensions (`extract_dimensions`)
  * Fix crash on "upload file" 3rd tab

  **COMPATIBILITY WARNING**

  Remove `extract_dimensions` or `extract_content_type` in uploader `process` call

## Ckeditor 4.3.0

  * Update CKEditor to version 4.11.1 full (8 November 2018)


## Ckeditor 4.2.4

  * Remove parameterize_filenames from paperclip backend (fix issue #738)
  * Don't delegate size method to data, read it from cached attribute data_file_size
  * Update CKEditor to version 4.7.1 full (28 Jun 2017)
  * Move method "assets_pipeline_enabled?" to main module and allow to change it from ckeditor config

## Ckeditor 4.2.3

  * Update CKEditor to version 4.6.2 full (12 Jan 2017)
  * Bugs fixes

## Ckeditor 4.2.2

  * Update CKEditor to version 4.6.1 full (08 Dec 2016)

## Ckeditor 4.2.1

  * Update CKEditor to version 4.5.11 (7 Sep 2016)
  * Remove polymorphic assetable association
  * Remove ckeditor_before_create_asset callback in controller
  * Bugs fixes

## Ckeditor 4.2.0

  * Rails 5 support
  * Update CKEditor to version 4.5.10 (13 Jul 2016)
  * Rubocop style fixes

  **COMPATIBILITY WARNING**

  Rename `read_dimensions` to `extract_dimensions` [https://github.com/galetahub/ckeditor/commit/4e6d8413cc71f40d2d58ab3d0cb8dad19dd96894]

## Ckeditor 4.1.6

  * Update CKEditor to version 4.5.6 (9 Dec 2015)
  * Support for CKEditor CDN (http://cdn.ckeditor.com/)
  * Load jquery library form jQuery CDN (https://code.jquery.com/)

## Ckeditor 4.1.5

  * Update ckeditor to Version 4.5.5 (12 Nov 2015)
  * Turkish locale
  * Bugs fixes

## Ckeditor 4.1.4

  * Update ckeditor to Version 4.5.4 (6 Oct 2015)
  * Bugs fixes

## Ckeditor 4.1.3

  * Update ckeditor to Version 4.5.2 (4 Aug 2015)
  * Bugs fixes

## Ckeditor 4.1.2

  * Update ckeditor to Version 4.4.7 (72 Plugins, 27 Jan 2015)
  * Bugs fixes

## Ckeditor 4.1.1

  * Update ckeditor to Version 4.4.6 (72 Plugins, 25 Nov 2014)
  * Add 'config.allowedContent = true;' by default
  * Setup toolbar groups configuration
  * Better content_type detection strategy

## Ckeditor 4.1.0

  * Update ckeditor to 4.4.2 Full Package version (72 Plugins, 24 Jun 2014)
  * Copy non-digested assets of ckeditor after assets precompile rake task
  * Starting gem changelog
