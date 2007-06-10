#!/usr/local/bin/ruby
module RubyQuiz
  
  #creates the pattern
  class Pattern
    attr_reader :colors
    attr_reader :value
    
    def initialize(length)
      @length = length
      @color_count = {:color1=>5, :color2=>1}
      @colors = Hash["0","black","1","red","2","orange","3","yellow","4","green","5","blue","6","indigo","7","violet","8","white","9","grey"]
      @value=""
      @flag_switch = true
      generate
    end

    def generate
      pick_new_colors
  	  (0..(@length.to_f/6).ceil).each do |i|
  	    @value += (@color1.to_s * @color_count[:color1]) + (@color2.to_s * @color_count[:color2])
        update_colors      
  	  end    
    end

    private
      def update_colors
        if @color_count[:color1] > 1
          @color_count[:color1]-=1
          @color_count[:color2]+=1  
        else
          @color_count[:color1],@color_count[:color2]=5,1
          @flag_switch ? add_flag : add_seperator
          pick_new_colors
        end    
      end

      def add_flag
        @value += "01840"
        @flag_switch = false
      end
  
      def add_seperator
        @value += "000"
        @flag_switch = true
      end
  
      def pick_new_colors
        @color1 = (rand*9).ceil
        @color2 = @color1 < 2 ? @color1 + 1 : @color1 - 1
      end  
  end

  # composes the pattern into a blanket
  class Blanket  
    attr_reader :ascii
    attr_accessor :scale
    def initialize(width=75,height=100, scale=2)
      @width, @height, @scale = width.to_i, height.to_i, scale.to_i
      @ascii, @html = ["",""]
      @pattern = Pattern.new(@width+@height)
      weave
    end

    private
      def weave
        0.upto(@height) do |i|
          @ascii += (@pattern.value[0 + i,@width])[0,@width] + "\n"
        end       
        puts @ascii + "\n"
        puts "open Mexican_Blanket.html in your interweb browser to see it in full color"
        html
      end

      def html
        @html = "<html>\n<head>\n<title>Mexican Blanket Solution</title>\n</head>\n"
        @html +="<body>\n"
        @html +="<style>\nbody{background:#ccc;font-weight:bold;text-align:center}\ndiv.pixel{float:left; width:#{@scale}px; height:#{@scale}px;}\n.wrapper{border:2px solid #fff; width:#{@width*@scale}px; margin:auto;}\n</style>\n"            
        @html +="<div class=\"wrapper\">\n"
        @ascii.split("\n").each do |line|
          line.gsub(/(.)/) do |char|
            @html += "<div class=\"pixel\" style=\"background:#{@pattern.colors[char]}\"></div>"          
          end
        end      
        @html += "\n<div style=\"clear:both\"></div>\n</div>"
        @html += "\n<div><pre>\n#{@ascii}\n</pre></div>\n"
        @html += "</body>\n</html>"
        to_file
      end
    
      def to_file
        output_file = File.open("Mexican_Blanket.html","w")do |f|
          f.write(@html)
        end      
      end
  end
end

# Blanket.new accepts height, width, and scale (used for html version)
if __FILE__ == $0
  blanket = RubyQuiz::Blanket.new(*ARGV)
end