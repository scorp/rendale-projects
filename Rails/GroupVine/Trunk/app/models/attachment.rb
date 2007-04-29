class Attachment < ActiveRecord::Base
  has_one :attachment_binary, :dependent => true

  def attach_file(the_file)
      (self.attachment_binary || self.create_attachment_binary).update_attributes(:data=>the_file)
      self.name = base_name(the_file.original_filename)
      self.content_type = the_file.content_type.chomp
      self
  end

  def base_name(file_name)
    name = File.basename(file_name)
    name.gsub(/[^\w._-]/, '')
  end
  
end
