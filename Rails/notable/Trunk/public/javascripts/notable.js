var Notable = {}
 
Notable.Page = function(){
	
	return {
		
		load_notes : function(){
			jQuery(".note").each(function(i)
			{	
				var note = jQuery(this)
				note.Draggable(
				{
					zIndex: 	1000,
					containment: '#container',
					handle: 'div.note_header',
					ghosting: true,
					opacity: .8
				});
 			}
			)
		}
		
			
	}
}()

Notable.init = function(){
	Notable.Page.load_notes();
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
