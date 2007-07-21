class Array  
  def max_slice
    return self-[0] if select{|k|k<0}.size==0
    return [max] if select{|k|k>=0}.size==0
    p={}
    each_with_index do |o,i|
      i.upto(size-1) do |j|
        p[eval(slice(i..j).join("+"))] = slice(i..j)
      end
    end
    p.max[1]
  end
end

x=[];1000.times{ |i| x<<(rand * (-500 + i)).floor};
puts x.max_slice.inspect

describe Array do
   it "should return the max slice" do
     input = [-1, 2, 5, -1, 3, -2, 1]
     input.max_slice.should == [2, 5, -1, 3]
   end  
end