class UserPhotosController < ApplicationController
before_filter :login_required, :only => [ :new, :edit, :create, :destroy ]
before_filter :find_user
layout "shared"

  def index
    @photos = @user.photos.paginate :page => params[:page], :per_page => 10, :order=>"id desc"
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml(:methods => [:small_photo_url])}
      format.rss  { render :action => "index.rxml", :layout => false }
    end
  end

  def new
    @photo = current_user.photos.new
  end

  def create
    @photo = current_user.photos.build(params[:photo])
    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        # format.html { redirect_to user_photos_path(current_user) }
        format.html {render :partial=>"shared/upload_success", :layout=>false}
        format.xml  { head :created, :location => user_photos_path(current_user) }
      else
        format.html {render :partial=>"shared/upload_failure", :layout=>false}
        # format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end
  
  def edit
  
  end 

  def update
    @photo = current_user.photos.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(params[:edit_photo])
        format.html
        format.js 
      else

      end
    end
  end
  
  def show
    @photo = Photo.find_by_user_id_and_id(params[:user_id], params[:id])
  end
  
  def destroy
  
  end

  def find_user
    @user = User.find_by_id(params[:user_id])
  end

end
