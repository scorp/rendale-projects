var Notable = {}
 
Notable.Page = function(){	
	return {
		add_note : function(note){
			alert(note.attr('id'))
			note.Draggable(
			{
				zIndex: 99999,
				containment: '#container',
				handle: 'div.note_header',
				ghosting: false,
				opacity: .8,
				onChange: function(){
					Notable.Page.MaxZIndex++;
					jQuery.post("/notes/update_position/" + jQuery(this).find(".noteId").html(), {x: jQuery(this).get()[0].offsetLeft, y: jQuery(this).get()[0].offsetTop, z: Notable.Page.MaxZIndex})
					jQuery(this).css("z-index", Notable.Page.MaxZIndex)
			}
			});
			note.css({position:"absolute", top: note.find(".noteY").html() + "px", left:note.find(".noteX").html() + "px", zIndex: note.find(".noteZ").html()})
			if (note.find(".noteZ").html() > Notable.Page.MaxZIndex)
			{
				Notable.Page.MaxZIndex = parseInt(note.find(".noteZ").html())
			}							
		},
		load_notes : function(){
			jQuery(".note").each(
				 function(i)
				 {	
				 	var note = jQuery(this)
				 	note.Draggable(
				 	{
				 		zIndex: 99999,
				 		containment: '#container',
				 		handle: 'div.note_header',
				 		ghosting: false,
				 		opacity: .8,
				 		onChange: function(){
				 			Notable.Page.MaxZIndex++;
				 			jQuery.post("/notes/update_position/" + jQuery(this).find(".noteId").html(), {x: jQuery(this).get()[0].offsetLeft, y: jQuery(this).get()[0].offsetTop, z: Notable.Page.MaxZIndex})
				 			jQuery(this).css("z-index", Notable.Page.MaxZIndex)
				 	}
				 	});
				 	 				note.css({position:"absolute", top: jQuery(this).find(".noteY").html() + "px", left:jQuery(this).find(".noteX").html() + "px", zIndex: jQuery(this).find(".noteZ").html()})
				 	if (jQuery(this).find(".noteZ").html() > Notable.Page.MaxZIndex)
				 	{
				 		Notable.Page.MaxZIndex = parseInt(jQuery(this).find(".noteZ").html())
				 	}				
			}
			);			
		},		
		MaxZIndex: 0,		
		UpdateMaxZIndex: function(){}
	}
}()

Notable.apply_styles = function(){
    var settings = {
        tl: { radius: 20 },
        tr: { radius: 20 },
        bl: { radius: 20 },
        br: { radius: 20 },
        antiAlias: true,
        autoPad: true,
        validTags: ["div"]
    };
    jQuery("#account_box").curvy(settings);
	jQuery(".signup_message").curvy(settings);
	jQuery(".login_message").curvy(settings);
}


Notable.init = function(){
	Notable.Page.load_notes();
	Notable.apply_styles();
}



jQuery.noConflict();
jQuery(document).ready(Notable.init)












//OLD STUFF**********************************************

//blind up or down an element based on if it is visible
function showhide(element, sender)
{
  if (element.style.display == 'none')
    { new Effect.Appear(element, {duration: .1});
	sender.innerHTML = "done";
	}
  else
    { new Effect.Fade(element, {duration: .1});
	sender.innerHTML = "add a file";
	}
};
