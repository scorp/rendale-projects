class AlbumsController < ApplicationController
  before_filter :login_required, :only => [ :new, :edit, :create, :destroy ]

  # GET /albums
  # GET /albums.xml
  def index
    @albums = Album.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @albums.to_xml }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])
    @photos = @album.photos
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @album.to_xml }
    end
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1;edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
        flash[:notice] = 'Album was successfully created.'
        format.html { redirect_to album_url(@album) }
        format.xml  { head :created, :location => album_url(@album) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors.to_xml }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        flash[:notice] = 'Album was successfully updated.'
        format.html { redirect_to album_url(@album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors.to_xml }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.xml  { head :ok }
    end
  end
end
