CKEDITOR.plugins.add('mbcvideos',
{
  init: function(editor)
  {

    var $mediaBrowser;
    $mediaBrowser = $("<div><div class='loading-dialog' style='width:inherit; height:inherit'></div></div>").dialog({
      title: 'Your Videos',
      modal: true,
      autoOpen: false,
      height: 510,
      width: 550,
      dialogClass: 'ckeditor-plugin'
     });

    editor.addCommand('insertMBCVideo',
    {
      exec : function(editor)
      {
        $mediaBrowser.dialog("open");
        $mediaBrowser.load("/items/video_search/?my_videos=" + CKEDITOR.currentInstance.name + '');
      }
    });

    editor.ui.addButton('MBCVideo',
    {
      label   : 'Insert Video from Drive',
      command : 'insertMBCVideo',
      icon    : '/assets/application/ckeditor-film-icon.png'
    });

  }
});