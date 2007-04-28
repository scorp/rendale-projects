# Extract PeopleCode from a PeopleSoft Project XML file  

require 'rubygems'
require 'hpricot'
require 'open-uri'

module PeopleSoftUtilities
  class ExtractPC
    attr_accessor :doc

    def extract(filename, folder="")    
      begin
      @doc = open(filename) { |f| Hpricot(f) }
      puts "file parsed"
    
        # name the folder based on the project name if a name is not provided
        folder = (@doc/"instance.PJM/rowset/row/szProjectName").inner_html unless folder!=""

        begin
          Dir.mkdir(folder)
        rescue SystemCallError => system_error
          puts "error creating project folder: " + system_error
          exit
        end
      
        #PCM instances are peoplecode
        @doc.search("instance.PCM").each do |item|      
           begin
             output_filename="#{folder}/"
             (0..6).each do |x|      
                 fragment = item.search("/rowset/row/szObjectValue_" + x.to_s).inner_html
                   if fragment != ""
                     if x != 0
                     output_filename += "."
                     end
                     output_filename += fragment
                   end
             end
            peoplecode_text = format_reserved_chars(item.search("peoplecode_text").inner_html)      
          
            if output_filename != ""
              puts "writing #{output_filename}"
              output_file = File.new(output_filename, "w+") << peoplecode_text
              output_file.close
            end
           rescue Exception => process_error
             puts "error processing file: " + process_error
           end
        end
        rescue Exception => parse_error
          puts "error parsing file: " + parse_error
        end
    end  
    
    def format_reserved_chars(raw)
        raw.gsub!("&amp;","&")
        raw.gsub!("&gt;",">")
        raw.gsub!("&lt;","<")
        raw.gsub!("&apos;","'")
        raw.gsub!("&quot;","\"")
    end      

  end
end

if __FILE__ == $0
  
  unless ARGV.length > 0 and FileTest.file?(ARGV[0]) and ARGV[0]=~/xml/i
    puts "you must provide a valid project file"
    exit
  end
  
  epc = PeopleSoftUtilities::ExtractPC.new
  epc.extract(*ARGV)

end