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