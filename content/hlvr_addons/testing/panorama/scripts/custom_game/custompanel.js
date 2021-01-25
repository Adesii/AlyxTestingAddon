var DEFAULT_DURATION = "300.0ms";
var DEFAULT_EASE = "linear";

function someting(data) {
	let temp =$("#paneltext");
	$.Msg(temp.id);
	$.Msg(temp);
	$.Msg("HELLO");
    //$.Msg("foo_event: ",data);
    //$.DispatchEvent( "ClientUI_FireOutput", data );
}
someting(20);
function OnMyEvent(){
	$.Msg("worked");
}