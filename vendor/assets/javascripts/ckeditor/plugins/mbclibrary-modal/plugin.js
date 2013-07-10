CKEDITOR.plugins.add('mbclibrary-modal',
{
  init: function(editor)
  {
    editor.addCommand('insertModalMBCLibrary',
    {
      exec : function(editor)
      {
        if ($('.media-selector').length){
          $('.media-selector').animate({'width': '1px'}, 300, function(){
            $('.media-selector').html('Loading media...');
          });
        }else{
          $(".modal-content").append("<div class='media-selector' style='width:0px;'>Loading media...</div>");
        };
        $('.media-selector').animate({'width': '200px'}, 300, function(){
          $('.media-selector').load("/items/video_search/?in_modal=true&library_videos=" + CKEDITOR.currentInstance.name + '');
        });
      }
    });

    editor.ui.addButton('ModalMBCLibrary',
    {
      label   : 'Insert My Big Campus Library Video',
      command : 'insertModalMBCLibrary',
      icon    : '/assets/application/ckeditor-youtube-icon.png'
    });

  }
});