class NoteFile < ActiveRecord::Base
	belongs_to :note
	before_destroy :remove_file  

	def add_file(file)
  	  self.filename = sanitize_filename(file.original_filename)
      self.systempath = self.note.user.login + "/" + self.note.id.to_s + "/"

	    self.filetype = file.content_type
	    
	    FileUtils.mkdir_p(RAILS_ROOT + "/files/" + self.systempath)

	    File.open(RAILS_ROOT + "/files/" + self.systempath + self.filename, "wb") { |f| f.write(file.read) }
	    File.open("tmp/" + self.note.id.to_s, "wb"){ |f| f.write("done")}

      if file.content_type=~/image/
            img = Magick::Image::read(RAILS_ROOT + "/files/" + self.systempath + self.filename).first        
			yxratio = (img.rows.to_f/img.columns.to_f) * 32
            xyratio = (img.columns.to_f/img.rows.to_f) * 32
            yxratio > xyratio ? img.scale!(32, yxratio.to_i) : img.scale!(xyratio.to_i,32)
  			begin
			img.crop!(Magick::CenterGravity,32,32)
            rescue 
            end
            img.write RAILS_ROOT + "/files/" + self.systempath + "thumb_" + self.filename
      end  
    return true
  end

  def remove_file
    delete_file = true
    self.note.note_files.each do | note_file |
      if note_file.filename = self.filename && note_file.id != note_file.id
        delete_file = false
      end
    end
    
      if delete_file == true
        begin
        File.delete(RAILS_ROOT + "/files/" + self.systempath + self.filename)
        File.delete(RAILS_ROOT + "/files/" + self.systempath + "thumb_" + self.filename)
        rescue
        end
      end
  end
  
  def sanitize_filename(name)
      return File.basename(name.gsub('\\', '/')).gsub(/[^\w\.\-]/,'_') 
  end
  
end
