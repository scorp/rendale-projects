class PhotosController < ApplicationController
  before_filter :login_required, :only => [ :new, :edit, :create, :destroy ]
  before_filter :find_album

  # GET /photos
  # GET /photos.xml
  def index
    @photos = @album.photos.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = @album.photos.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  # GET /photos/new
  def new
    @photo = @album.photos.build
  end

  # GET /photos/1;edit
  def edit
    @photo = current_user.photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = @album.photos.build(params[:photo])

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :created, :location => photo_url(@photo) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = @album.photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = @album.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.xml  { head :ok }
    end
  end
  
  def find_album
    @album = Album.find(params[:album_id])
  end
  
end
