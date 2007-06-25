class UploadController < ApplicationController

  def index
  
  end

  def create
    album = Album.new(params[:album][:name], params[:album][:description]).load_from_zip_file(params[:album][:zip_file])
    redirect_to album.url
  end

end
