class NoteFile < ActiveRecord::Base
	belongs_to :note
	before_destroy :remove_file  

	def add_file(file)
	  begin
  	  self.filename = sanitize_filename(file.original_filename)
      self.systempath = self.note.user.login + "/" + self.note.id.to_s + "/"

	    if self.filename.split(".").length > 1
	      self.filetype = self.filename.split(".")[1]
      else
	      self.filetype = ""
	    end
	    
	    FileUtils.mkdir_p(RAILS_ROOT + "/files/" + self.systempath)

	    File.open(RAILS_ROOT + "/files/" + self.systempath + self.filename, "wb") { |f| f.write(file.read) }
	    File.open("tmp/" + self.note.id.to_s, "wb"){ |f| f.write("done")}

      # create thumbnails of images
      if self.filetype.to_s.upcase == "JPEG" || self.filetype.to_s.upcase == "JPG" || self.filetype.to_s.upcase == "GIF" || self.filetype.to_s.upcase == "PNG"
            img = Magick::Image::read(RAILS_ROOT + "/files/" + self.systempath + self.filename).first        
            xyratio = (img.columns.to_f/img.rows.to_f) * 100
            thumb = img.scale(xyratio.to_i,100)
            thumb.write RAILS_ROOT + "/files/" + self.systempath + "thumb_" + self.filename
      end  

	  rescue Exception
      puts Exception.inspect
    return false
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
      # get only the filename, not the whole path and
      # replace all none alphanumeric, underscore or periods with underscore
      return File.basename(name.gsub('\\', '/')).gsub(/[^\w\.\-]/,'_') 
  end
  
end
