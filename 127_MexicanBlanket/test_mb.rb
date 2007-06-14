require 'test/unit'
require 'mb'

class TestMb < Test::Unit::TestCase
  def setup
  	@pattern = RubyQuiz::Pattern.new(175)
  	@blanket = RubyQuiz::Blanket.new()

	#adding accessors for testing
	RubyQuiz::Pattern.class_eval("attr_accessor :color1")
	RubyQuiz::Pattern.class_eval("attr_accessor :color2")
	RubyQuiz::Pattern.class_eval("attr_accessor :color_count")
  end
  
  # test pattern
  def test_color_picker
  	@pattern.send(:pick_new_colors)
  	assert (1..9).include?(@pattern.color1)
  	assert (1..9).include?(@pattern.color2)
  	assert @pattern.color2 == @pattern.color1 - 1, "color1: #{@pattern.color1}, color2: #{@pattern.color2}" unless @pattern.color1 <=1
  	assert @pattern.color2 == @pattern.color1 + 1, "color1: #{@pattern.color1}, color2: #{@pattern.color2}" if @pattern.color1 <= 1
  end
  
  def test_add_flag
  	@pattern.send(:add_flag)
  	assert @pattern.value.include?("01840"), "#{@pattern.value} does not include 01840"
  end
  
  def test_add_seperator
  	@pattern.send(:add_flag)
  	assert @pattern.value.include?("000"), "#{@pattern.value} does not include 000"
  end

  def test_update_colors
  	orig_color1 = @pattern.color1
  	assert @pattern.color_count.include?(:color1) && @pattern.color_count.include?(:color2)
    @pattern.color_count[:color1],@pattern.color_count[:color2]=4,2
    @pattern.send(:update_colors) 
    @pattern.send(:update_colors) 
    @pattern.send(:update_colors) 
    @pattern.send(:update_colors) 
    assert @pattern.color_count[:color1] + @pattern.color_count[:color2] == 6, "total should always be 6"
	assert @pattern.color_count[:color1] == 5
	assert @pattern.value.include?("01840")
	#assert_not_equal orig_color1, @pattern.color1, "original color1 #{orig_color1}...current color1 #{@pattern.color1}"	
  end
  
  def test_pattern
  	assert_equal @pattern.value.length, 175, "#{@pattern.value.length} is not equal to 175...#{@pattern}"
	assert_equal @pattern.to_s, @pattern.value
  end
  
  def test_blanket
  	pattern1=""
  	pattern2 = @blanket.ascii.split("").reject{|i|i=="\n"}.collect{|i| "<#{i}>"}.join
  	puts pattern1.length
  	puts pattern1[0..355]
  	puts pattern2.length
  	puts pattern2[0..355]
  	puts (pattern1.split("") - pattern2.split("")).join
  end
	
end