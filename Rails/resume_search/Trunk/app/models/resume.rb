class Resume < Attachment
  belongs_to :user
  acts_as_ferret :fields=>[:clear_text]

  def load_file(the_file)
    self.data = the_file.read
    the_file.rewind
    
    tmpfile=File.open("temp.doc","wb")
    tmpfile << the_file.read
    tmpfile.close()
    self.clear_text = `antiword temp.doc`
    the_file.rewind
    
    self.date = Time.now

    self.name = sanitize_filename(the_file.original_filename)
    self.content_type = the_file.content_type.chomp
    
    self
  end
  
  private
  def sanitize_filename(value)
    just_filename = value.gsub(/^.*(\\|\/)/, '')
    just_filename.gsub(/[^\w\.\-]/,'_') 
  end


end