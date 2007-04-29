// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function process_update(obj) {
	idexp = /\d{1,}/;
	field_id = idexp.exec(obj.id);	
	field_value = obj.id.substr(obj.id.lastIndexOf("_") + 1,obj.id.length);	
	params = "id=" + field_id + "&field_value=" + obj.value + "&field_to_update=" + field_value;
	new Ajax.Request('/log/save_field', {asynchronous:true, evalScripts:true, parameters:params });
}

