require 'erb'

class Album
  ALLOWED_TYPES=%w(jpg jpeg gif png tif bmp)
  attr_accessor :zip_file, :name, :folder, :photos, :url, :description

  def initialize album_name, album_description
    @photos, @name, @title, @description = [], album_name.gsub(/[\s\.\$\!\/]/,"_"), album_name, album_description
    i=1
    while File.exist?("#{RAILS_ROOT}/public/galleries/#{@name}")
       @name = @name + i.to_s
       i+=1
    end
    @folder = "#{RAILS_ROOT}/public/galleries/#{@name}"
    self
  end
  
  def load_from_zip_file zip_file
    expand_zip(write_temp_file(zip_file))
    generate_html
  end

  def generate_html
    output = ERB.new(File.open("#{RAILS_ROOT}/app/views/gallery.rhtml","r").read)    
    html=output.result(binding)
    File.open("#{@folder}/index.html","w") do |file|
      file << html
    end    
    @url="/galleries/#{@name}/index.html"
    self    
  end

  def write_temp_file zip_file
    temp_file = "#{RAILS_ROOT}/tmp/#{@name}.zip"
    File.open(temp_file,"w") do |file|
      file.write zip_file.read
    end
    temp_file
  end

  def expand_zip temp_file
    FileUtils.mkdir_p(@folder)
    Zip::ZipFile::open temp_file do |zip|
      zip.each do |zipped_file|
       filename = zipped_file.name.split(/\//).last
       extension = filename.split(/\./).last
        if ALLOWED_TYPES.include?(extension.downcase) && !filename.match(/^\./)
          zip.extract(zipped_file, "#{@folder}/#{filename}")
          @photos << Photo.new(filename, @name)
          @photos.last.create_thumbnail
        end
        FileUtils.mkdir_p("#{@folder}/thumbs")
      end
    end            
    FileUtils.rm temp_file    
  end
  
end