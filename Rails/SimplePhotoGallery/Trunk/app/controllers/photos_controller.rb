class PhotosController < ApplicationController
  before_filter :login_required, :only => [ :new, :edit, :create, :destroy ]

  # GET /photos
  # GET /photos.xml 
  def index
    @photos = Photo.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(:params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  # GET /photos/new
  def new
    @photo = Photos.new
  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.build(params[:photo])

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to photo_url(@album, @photo) }
        format.xml  { head :created, :location => photo_url(@album, @photo) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

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
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to edit_album_path @album }
      format.xml  { head :ok }
    end
  end  
end
