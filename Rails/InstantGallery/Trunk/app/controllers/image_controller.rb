class ImageController < ApplicationController
  def rotate
    photo = Photo.new(params[:photo_name],params[:gallery_name])
    photo.rotate("cw")
    redirect_to photo.gallery_url
  end
end
