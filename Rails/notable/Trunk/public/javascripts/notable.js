var Notable = {}
 
Notable.Page = function(){
	
	return {
		
		load_notes : function(){
			jQuery(".note").each(function(i)
			{	
				var note = jQuery(this)
				note.Draggable(
				{
					zIndex: 1,
					containment: '#container',
					handle: 'div.note_header',
					ghosting: false,
					opacity: .8,
					onChange: function(){
						jQuery.post("/notes/update_position/" + jQuery(this).find(".noteId").html(), {x: jQuery(this).get()[0].offsetLeft, y: jQuery(this).get()[0].offsetTop, z: jQuery(this).find(".noteZ").html()})

				}
				});
 			note.css({position:"absolute", top: jQuery(this).find(".noteY").html() + "px", left:jQuery(this).find(".noteX").html() + "px"})
 			}
			)
			
		},
		
		MaxZIndex: 0,
		
		UpdateZIndex: function(){
		
		}
				
			
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
