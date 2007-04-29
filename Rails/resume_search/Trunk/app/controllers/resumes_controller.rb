class ResumesController < ApplicationController
  before_filter :login_required
  layout "main"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @resume_pages, @resumes = paginate :resumes, :per_page => 10
  end

  def show
    @resume = Resume.find(params[:id])
  end

  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new.load_file(params[:resume][:data])
    if @resume.save
      flash[:notice] = 'Resume was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  def update
    @resume = Resume.find(params[:id])
    if @resume.update_attributes(params[:resume])
      flash[:notice] = 'Resume was successfully updated.'
      redirect_to :action => 'show', :id => @resume
    else
      render :action => 'edit'
    end
  end

  def destroy
    Resume.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  
  
end
