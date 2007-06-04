class ImageAttachment < ActiveRecord::Base
  belongs_to :user
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 5.megabytes,
                 :thumbnails => { :tiny => '75!x75!', :thumb => '100!x100!', :small => '240!x240!', :large => '500!x500!'},
                 :processor => 'Rmagick'  
  validates_as_attachment
end

module Magick # :nodoc:
  class Image # :nodoc:
    def crop_resized(ncols, nrows, gravity=CenterGravity)
        copy.crop_resized!(ncols, nrows, gravity)
    end

    def crop_resized!(ncols, nrows, gravity=CenterGravity)
        if ncols != columns || nrows != rows
            scale = [ncols/columns.to_f, nrows/rows.to_f].max
            resize!(scale*columns+0.5, scale*rows+0.5)
        end
        crop!(gravity, ncols, nrows) if ncols != columns || nrows != rows
        self
    end
  end
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
            img.crop_resized!(*size)
          else
            img.change_geometry(size.to_s) { |cols, rows, image| image.crop_resized!(cols, rows) }
          end
          self.temp_path = write_to_temp_file(img.to_blob)
        end
      end
    end
  end
end
