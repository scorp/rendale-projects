class Photo
  attr_accessor :gallery_url, :filename, :url, :thumbnail_url, :caption, :filesystem_path, :thumbnail_filesystem_path
  
  def initialize filename, gallery_name
    @filename = filename
    @url = "/galleries/#{gallery_name}/#{filename}"
    @thumbnail_url = "/galleries/#{gallery_name}/thumbs/#{filename}"
    @thumbnail_filesystem_path = "/galleries/#{gallery_name}/thumbs/#{filename}"
    @filesystem_path = "#{RAILS_ROOT}/public/galleries/#{gallery_name}/#{filename}"
    @thumbnail_filesystem_path = "#{RAILS_ROOT}/public/galleries/#{gallery_name}/thumbs/#{filename}"
    @gallery_url = "/galleries/#{gallery_name}/index.html"
    self
  end

  def create_thumbnail
    begin
        file = File.open(@filesystem_path,"r")
        thumbnail = Magick::Image.read(file).first.crop_resized(100,100, Magick::CenterGravity)
        orig = Magick::Image.read(file).first.crop_resized(600,600, Magick::CenterGravity)
        thumbnail.write(@thumbnail_filesystem_path)
        orig.write(@filesystem_path)
    rescue Exception => error
      raise error
    end
    self
  end
  
  def rotate direction    
    [@filesystem_path, thumbnail_filesystem_path].each do |path|
      photo = Magick::Image.read(path).first
      photo = direction == "cw" ? photo = photo.rotate(90) : photo.rotate(270)
      photo.write(path)          
    end
  end
  
  def delete    
    [@filesystem_path, thumbnail_filesystem_path].each do |path|
      FileUtils.rm(path)
    end
  end
  
end