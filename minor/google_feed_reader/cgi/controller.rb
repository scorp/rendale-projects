#! /usr/bin/ruby
require 'rubygems'
require 'cgi'
       
module FeedReader
  class FeedStore 
    attr_accessor :storage_file
        
    def initialize(cookie)
      max_file_number = 0
      if cookie.empty? then
        cookie = Dir.entries("../feeds/").each do |entry|
          if File.stat("../feeds/" + entry).file?
            begin   
              current_file_number = File.basename(entry).gsub!(/feeds/,"").to_i
            rescue Exception => e
              puts "error: " + e
            end
            max_file_number = current_file_number > max_file_number ? current_file_number : max_file_number
          end
          @storage_file = "feeds#{(max_file_number + 1).to_s}"
          File.new("../feeds/" + @storage_file,"w").close
        end
      else 
        @storage_file = cookie.value[0]
      end
    end
  end
   
  class Controller

    attr_accessor :cgi
    attr_accessor :feed_store
    
    def initialize
      @cgi = CGI.new("html3")
      @feed_store = FeedStore.new(@cgi.cookies["feed_store"])
      @cookie = CGI::Cookie.new("feed_store", @feed_store.storage_file)
    end

    def add_feed()
      File.open("../feeds/#{@feed_store.storage_file}", "a+") do |file|
        file << CGI.unescapeHTML(@cgi.params['add'][0]) + "\n"
      end
    #@cgi.out("cookie"=>@cookie){@cgi.html{@cgi.body{"done"}}}
    send_feeds
    end

    def send_feeds()
      @cgi.out("cookie"=>@cookie) {
       File.open("../feeds/#{@cookie.value}", "r") do |file|
         feeds="<div id='saved_feeds'>\n"
         file.each_line{|line| feeds+="<div class='feed'>#{line.chomp("\n")}</div>\n"}
         feeds+="</div>\n"
       end
        # @cgi.html{
        #         @cgi.head{} +
        #         @cgi.body{"\n" +
        #           File.open("../feeds/#{@cookie.value}", "r") do |file|
        #             feeds="<div id='saved_feeds'>\n"
        #             file.each_line{|line| feeds+="<div class='feed'>#{line.chomp("\n")}</div>\n"}
        #             feeds+="</div>\n"
        #           end
        #         }
        #       }
      }
    end
  end
end

if __FILE__ == $0
  fr = FeedReader::Controller.new
  if fr.cgi.has_key?("add")
    fr.add_feed
  else
    fr.send_feeds
  end
end
