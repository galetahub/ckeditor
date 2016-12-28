CKEDITOR.plugins.add('mbcvideos-modal',
{
  init: function(editor)
  {
    editor.addCommand('insertModalMBCVideo',
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
          $('.media-selector').load("/items/video_search/?in_modal=true&my_videos=" + CKEDITOR.currentInstance.name + '');
        });
      }
    });

    editor.ui.addButton('ModalMBCVideo',
    {
      label   : 'Insert Video from Drive',
      command : 'insertModalMBCVideo',
      icon    : '/assets/application/ckeditor-film-icon.png'
    });

  }
});