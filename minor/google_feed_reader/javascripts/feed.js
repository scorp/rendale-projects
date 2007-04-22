//feed = new google.feeds.Feed("http://www.digg.com/rss/index.xml")
var RENDALE = {};
RENDALE.FeedReader = {};

RENDALE.FeedReader.Feed = function(url, controller){
	this.url = url;
	this.html = "";
	this.dom_id = "";
	this.feed = new google.feeds.Feed(url);	
	this.controller = controller;

	this.feed.setNumEntries(5);
	this.feed.MIXED_FORMAT;
}
RENDALE.FeedReader.Feed.prototype.get_html = function(){
	return this.html
}
RENDALE.FeedReader.Feed.prototype.load = function(i){
	var feed_obj = this;
	feed_obj.dom_id = "feed_" + i;
	this.feed.load(
		function(result){
			if(!result.error){
				var html = "<div class='feed' id='" + feed_obj.dom_id +"'><h3><a href='" + result.feed.link + "' target='_blank'>" + result.feed.title + "</a></h3><ol class='feed_items'>";
				
				$.each(result.feed.entries,function(i,entry){
					html += "<li id='" + result.feed.title + "_" + i + "'><a href='" + entry.link + "' target='_blank'>"
					html += entry.title + "</a>"
					html += "<div class='entry_snippet'>" + entry.contentSnippet.replace(/<embed[\s\S]*>/,'') + "</div>"
					html += "</li>";
					}
				)
				
				html += "</ol></div>"
				feed_obj.html = html;
				feed_obj.controller.feeds.push(feed_obj)
				feed_obj.controller.render(feed_obj)
			}
			else
			{
				alert('No Feed defined for that URL');
			}

		}
	)
} 
// end of Feed


RENDALE.FeedReader.Controller = function(){
	this.feeds = new Array();	
}
RENDALE.FeedReader.Controller.prototype.add_feed = function(url){
	var new_feed = new RENDALE.FeedReader.Feed(url, this);
	new_feed.load(this.feeds.length)
	return this;
}

RENDALE.FeedReader.Controller.prototype.render = function(feed){
			$('#feeds').append(feed.html);
			$('#' + feed.dom_id).fadeIn('slow');
}
// end of Controller

RENDALE.FeedReader.Application = function(){
		var controller;
		var add = function(){
			var url = $('#new_feed').val();
			controller.add_feed(url);
		}

		return {
			init : function(){
				controller = new RENDALE.FeedReader.Controller();
				controller.add_feed("http://www.digg.com/rss/index.xml");
				controller.add_feed("http://feeds.feedburner.com/37signals/beMH");
				controller.add_feed("http://feeds.feedburner.com/too-biased/xml");
				
				$('#add').bind('click', add);
			}
		}
}()
// end of Application

$(document).ready(RENDALE.FeedReader.Application.init)