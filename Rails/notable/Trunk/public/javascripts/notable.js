//blind up or down an element based on if it is visible
function showhide(element, sender)
{
  if (element.style.display == 'none')
    { new Effect.BlindDown(element, {duration: .4});
	sender.innerHTML = "done";
	}
  else
    { new Effect.BlindUp(element, {duration: .4});
	sender.innerHTML = "add a file";
	}
};
