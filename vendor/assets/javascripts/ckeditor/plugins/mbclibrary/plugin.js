CKEDITOR.plugins.add('mbclibrary',
{
  init: function(editor)
  {

    var $mediaBrowser;
    $mediaBrowser = $("<div><div class='loading-dialog' style='width:inherit; height:inherit'></div></div>").dialog({
      title: 'MBC Library Videos',
      modal: true,
      autoOpen: false,
      height: 510,
      width: 550,
      dialogClass: 'ckeditor-plugin'
     });

    editor.addCommand('insertMBCLibrary',
    {
      exec : function(editor)
      {
        $mediaBrowser.dialog("open");
        $mediaBrowser.load("/items/video_search/?library_videos=" + CKEDITOR.currentInstance.name + '');
      }
    });

    editor.ui.addButton('MBCLibrary',
    {
      label   : 'Insert My Big Campus Library Video',
      command : 'insertMBCLibrary',
      icon    : '/assets/application/ckeditor-youtube-icon.png'
    });

  }
});