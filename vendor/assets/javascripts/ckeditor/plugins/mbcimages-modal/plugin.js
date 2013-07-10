CKEDITOR.plugins.add('mbcimages-modal',
{
  init: function(editor)
  {
    editor.addCommand('insertModalMBCImage',
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
          $('.media-selector').load("/documents/get_images/?in_modal=true&ckinstance=" + CKEDITOR.currentInstance.name + '' );
        });
      }
    });

    editor.ui.addButton('ModalMBCImage',
    {
      label   : 'Insert My Big Campus Image',
      command : 'insertModalMBCImage',
      icon    : 'image'
    });

  }
});