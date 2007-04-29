class ScheduleEntriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @schedule_entry_pages, @schedule_entries = paginate :schedule_entries, :per_page => 10
  end

  def show
    @schedule_entry = ScheduleEntry.find(params[:id])
  end

  def new
    @schedule_entry = ScheduleEntry.new
  end

  def create
    @schedule_entry = ScheduleEntry.new(params[:schedule_entry])
    if @schedule_entry.save
      flash[:notice] = 'ScheduleEntry was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @schedule_entry = ScheduleEntry.find(params[:id])
  end

  def update
    @schedule_entry = ScheduleEntry.find(params[:id])
    if @schedule_entry.update_attributes(params[:schedule_entry])
      flash[:notice] = 'ScheduleEntry was successfully updated.'
      redirect_to :action => 'show', :id => @schedule_entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    ScheduleEntry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
