class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :picture, :as=>:attachable, :dependent=>true
  has_one :resume, :as=>:attachable, :dependent=>true

  def update_picture(the_image)
    if !the_image.nil? and the_image.length > 0 and (the_image.content_type.chomp == 'image/jpeg' or the_image.content_type.chomp == 'image/gif' or the_image.content_type.chomp == 'image/png')
      (self.picture || self.create_picture).attach_file(the_image).save
    end
  end

  def update_resume(resume)
      (self.resume || self.create_resume).attach_file(resume).save
  end
    
end
