class Photo < ImageAttachment
  belongs_to :album
  
  def small_photo_url
    self.public_filename(:small)
  end
end