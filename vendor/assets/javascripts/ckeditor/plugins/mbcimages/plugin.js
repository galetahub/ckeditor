CKEDITOR.plugins.add('mbcimages',
{
  init: function(editor)
  {

    var $mediaBrowser;
    $mediaBrowser = $("<div><div class='loading-dialog' style='width:inherit; height:inherit'></div></div>").dialog({
      title: 'Insert Image',
      modal: true,
      autoOpen: false,
      height: 380,
      width: 600,
      dialogClass: 'ckeditor-plugin'
     });

    editor.addCommand('insertMBCImage',
    {
      exec : function(editor)
      {
        $mediaBrowser.dialog("open");
        $mediaBrowser.load("/documents/get_images/?ckinstance=" + CKEDITOR.currentInstance.name + '' );
      }
    });

    editor.ui.addButton('MBCImage',
    {
      label   : 'Insert My Big Campus Image',
      command : 'insertMBCImage',
      icon    : 'image'
    });

  }
});