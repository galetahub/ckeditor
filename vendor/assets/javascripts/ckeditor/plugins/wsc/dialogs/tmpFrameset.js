function doLoadScript( url )
{
	if ( !url )
		return false ;

	var s = document.createElement( "script" ) ;
	s.type = "text/javascript" ;
	s.src = url ;
	document.getElementsByTagName( "head" )[ 0 ].appendChild( s ) ;

	return true ;
}

var opener;
function tryLoad()
{
	opener = window.parent;

	// get access to global parameters
	var oParams = window.opener.oldFramesetPageParams;

	// make frameset rows string prepare
	var sFramesetRows = ( parseInt( oParams.firstframeh, 10 ) || '30') + ",*," + ( parseInt( oParams.thirdframeh, 10 ) || '150' ) + ',0' ;
	document.getElementById( 'itFrameset' ).rows = sFramesetRows ;

	// dynamic including init frames and crossdomain transport code
	// from config sproxy_js_frameset url
	var addScriptUrl = oParams.sproxy_js_frameset ;
	doLoadScript( addScriptUrl ) ;
}