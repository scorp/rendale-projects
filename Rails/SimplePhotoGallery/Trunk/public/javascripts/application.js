// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var YAPA = {};

YAPA.PageController = Class.create();
YAPA.PageController.prototype = {
	initialize: function(){
		
	},
	
	renderPage: function(){
		
	},
	
	upload_photos: function(){
		$$("form").each(function(form, i){
				var id = (i + 1).toString()
				if ($F("upload_control_" + id)) 
				{
					$("loading_" + id).setStyle({display: "inline"})
					form.submit();
				}
			}
		)
	},
	
	render_upload_success: function(id, edit_image){
		$("loading_" + id).setStyle({display: "none"});
		// $("upload_wrapper_" + id).replace('<div class="upload_result"><div class="upload_success">Photo Upload Success!</div>' + edit_image + '</div>')
		$("upload_wrapper_" + id).innerHTML = edit_image
	},
	
	render_upload_failure: function(id, message){
		$("loading_" + id).setStyle({display: "none"})		
		new Insertion.After("upload_target_" + id, '<div class="upload_failure">' + message + '</div>')
	},
	
	addClassToElement: function(elem, class){
		try
		{	
			$(elem).addClassName(class)
		}		
		catch(e)
		{}
	}
	
}


Event.observe(window, 'load', function() {
	YAPA.page_controller = new YAPA.PageController()
	YAPA.page_controller.renderPage();	
});