require 'RMagick'

class Picture < Attachment

   
  def attach_file(the_file)
    if the_file.length > 2.megabytes
    else
      thumbnail = Magick::Image.from_blob(the_file.read).first
      thumbnail.change_geometry!('200x200') { |cols, rows, img|
      img.resize!(cols, rows)
      }
      thumbnail = thumbnail.crop(Magick::CenterGravity,150,150)
      binary = self.attachment_binary || self.create_attachment_binary()
      binary.data = thumbnail.to_blob
      binary.save
      self.name = base_name(the_file.original_filename)
      self.content_type = the_file.content_type.chomp
      self
    end
  end
    
end