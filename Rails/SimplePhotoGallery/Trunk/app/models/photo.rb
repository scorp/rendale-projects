class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :album
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 5.megabytes,
                 :thumbnails => { :tiny => '75!x75!', :thumb => '100!x100!', :small => '240!x240!', :large => '500!x500!'},
                 :processor => 'Rmagick'

  def small_photo_url
    self.public_filename(:small)
  end

  validates_as_attachment
end

module Technoweenie # :nodoc:
  module AttachmentFu # :nodoc:
    module Processors
      module RmagickProcessor
        protected :resize_image
        def resize_image(img, size)
          size = size.first if size.is_a?(Array) && size.length == 1 && !size.first.is_a?(Fixnum)
          if size.is_a?(Fixnum) || (size.is_a?(Array) && size.first.is_a?(Fixnum))
            size = [size, size] if size.is_a?(Fixnum)
            img = kludge_crop_resized(img, *size)
          else
            img.change_geometry(size.to_s) { |cols, rows, image| image.crop_resized!(cols, rows) }
          end
          self.temp_path = write_to_temp_file(img.to_blob)
        end
        
        def kludge_crop_resized(img, ncols, nrows)
            img2 = img.copy
            if ncols != img2.columns || nrows != img2.rows
                scale = [ncols/img2.columns.to_f, nrows/img2.rows.to_f].max
                img2 = img2.resize(scale*img2.columns+0.5, scale*img2.rows+0.5)
            end
            img2 = img2.crop(Magick::CenterGravity, ncols, nrows) if ncols != img2.columns || nrows != img2.rows
            img2
        end
        
        
      end
    end
  end
end