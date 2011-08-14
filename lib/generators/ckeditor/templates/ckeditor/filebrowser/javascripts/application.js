(function($) {
  $.QueryString = (function(a) {
    if (a == "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i)
    {
      var p=a[i].split('=');
      if (p.length != 2) continue;
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
  })(window.location.search.substr(1).split('&'))
})(jQuery);

$(document).ready(function(){
  $("div.gal-item div.gal-inner-holder")
    .live('mouseover', function(e){
      $(this).addClass('hover');
    })
    .live('mouseout', function(e){
      $(this).removeClass('hover');
    })
    .live('click', function(e){
      var url = $(this).parents('div.gal-item').data('url');
      CKEDITOR.tools.callFunction(CKEditorFuncNum, url);
      window.close();
    });
  
  $("div.gal-item a.gal-del").live('ajax:complete', function(xhr, status){
    $(this).parents('div.gal-item').remove();
  });
});

// Collection of all instances on page
qq.FileUploader.instances = new Object();

/**
 * Class that creates upload widget with drag-and-drop and file list
 * @inherits qq.FileUploaderBasic
 */
qq.FileUploaderInput = function(o){
    // call parent constructor
    qq.FileUploaderBasic.apply(this, arguments);
    
    // additional options    
    qq.extend(this._options, {
        element: null,
        // if set, will be used instead of qq-upload-list in template
        listElement: null,
        
        template_id: '#fileupload_tmpl',       
        
        classes: {
            // used to get elements from templates
            button: 'fileupload-button',
            drop: 'fileupload-drop-area',
            dropActive: 'fileupload-drop-area-active',
            list: 'fileupload-list',
            preview: 'fileupload-preview',
                        
            file: 'fileupload-file',
            spinner: 'fileupload-spinner',
            size: 'fileupload-size',
            cancel: 'fileupload-cancel',

            // added to list item when upload completes
            // used in css to hide progress spinner
            success: 'fileupload-success',
            fail: 'fileupload-fail'
        }
    });
    // overwrite options with user supplied    
    qq.extend(this._options, o);       

    this._element = document.getElementById(this._options.element);
    this._listElement = this._options.listElement || this._find(this._element, 'list');
    
    this._classes = this._options.classes;
        
    this._button = this._createUploadButton(this._find(this._element, 'button'));        
    
    //this._setupDragDrop();
    
    qq.FileUploader.instances[this._element.id] = this;
};

// inherit from Basic Uploader
qq.extend(qq.FileUploaderInput.prototype, qq.FileUploaderBasic.prototype);

qq.extend(qq.FileUploaderInput.prototype, {
    /**
     * Gets one of the elements listed in this._options.classes
     **/
    _find: function(parent, type){                                
        var element = qq.getByClass(parent, this._options.classes[type])[0];        
        if (!element){
          alert(type);
            throw new Error('element not found ' + type);
        }
        
        return element;
    },
    _setupDragDrop: function(){
        var self = this,
            dropArea = this._find(this._element, 'drop');                        

        var dz = new qq.UploadDropZone({
            element: dropArea,
            onEnter: function(e){
                qq.addClass(dropArea, self._classes.dropActive);
                e.stopPropagation();
            },
            onLeave: function(e){
                e.stopPropagation();
            },
            onLeaveNotDescendants: function(e){
                qq.removeClass(dropArea, self._classes.dropActive);  
            },
            onDrop: function(e){
                dropArea.style.display = 'none';
                qq.removeClass(dropArea, self._classes.dropActive);
                self._uploadFileList(e.dataTransfer.files);    
            }
        });
                
        dropArea.style.display = 'none';

        qq.attach(document, 'dragenter', function(e){     
            if (!dz._isValidFileDrag(e)) return; 
            
            dropArea.style.display = 'block';            
        });                 
        qq.attach(document, 'dragleave', function(e){
            if (!dz._isValidFileDrag(e)) return;            
            
            var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
            // only fire when leaving document out
            if ( ! relatedTarget || relatedTarget.nodeName == "HTML"){               
                dropArea.style.display = 'none';                                            
            }
        });                
    },
    _onSubmit: function(id, fileName){
        qq.FileUploaderBasic.prototype._onSubmit.apply(this, arguments);
        this._addToList(id, fileName);  
    },
    _onProgress: function(id, fileName, loaded, total){
        qq.FileUploaderBasic.prototype._onProgress.apply(this, arguments);

        var item = this._getItemByFileId(id);
        var size = this._find(item, 'size');
        
        var text; 
        if (loaded != total){
            text = Math.round(loaded / total * 100) + '% from ' + this._formatSize(total);
        } else {                                   
            text = this._formatSize(total);
        }          
        
        qq.setText(size, text);
    },
    _onComplete: function(id, fileName, result){
        qq.FileUploaderBasic.prototype._onComplete.apply(this, arguments);

        var item = this._getItemByFileId(id);
        var asset = result.asset ? result.asset : result;
        
        if (asset && asset.id){
            qq.addClass(item, this._classes.success);
            
            asset.size = this._formatSize(asset.size);
            asset.controller = (asset.type.toLowerCase() == "ckeditor::picture" ? "pictures" : "attachment_files");
            
            $(item).replaceWith($(this._options.template_id).tmpl(asset));
        } else {
            qq.addClass(item, this._classes.fail);
        }
    },
    _addToList: function(id, fileName){
        if (this._listElement) {
          if (this._options.multiple === false) {
            $(this._listElement).empty();
          }
          
          var asset = {
            id: 0, 
            filename: this._formatFileName(fileName), 
            size: 0,
            format_created_at: '',
            url_content: "#",
            controller: "assets",
            url_thumb: "/javascripts/ckeditor/filebrowser/images/preloader.gif"
          };
          
          var item = $(this._options.template_id)
            .tmpl(asset)
            .attr('qqfileid', id)
            .prependTo( this._listElement );
          
          item.find('div.img').addClass('preloader');
          
          this._bindCancelEvent(item);
        }
    },
    _getItemByFileId: function(id){
        return $(this._listElement).find('div[qqfileid=' + id  +']').get(0); 
    },
    /**
     * delegate click event for cancel link 
     **/
    _bindCancelEvent: function(element){
        var self = this,
            item = $(element);        
        
        item.find('a.' + this._classes.cancel).bind('click', function(e){
          self._handler.cancel( item.attr('qqfileid') );
          item.remove();
          qq.preventDefault(e);
          return false;
        });
    }
});
