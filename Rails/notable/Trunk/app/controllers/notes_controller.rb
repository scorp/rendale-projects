class NotesController < ApplicationController
before_filter :login_required  
  
  def index
    @notes = current_user.notes.find(:all,:order => "date desc, id desc")
  end
  
  def new
    @note = current_user.notes.create(:date=>Time.now)
    @newstyle = 'style="z-index:9999"'
    render :update do |page|
      page.insert_html(:top, 'notes_block', :partial => 'note_listing', 
:object => @note)
    end
  end
  
  def update_descr
    @note = Note.find(params[:id])
    @note.description=params[:value]
    @note.save   
    render :text=> RedCloth.new(@note.description).to_html, :layout=>false
  end
  
  def get_descr
    @note = current_user.notes.find(params[:id])
    if @note.description.nil?
      render :nothing => true    
    else
      render :text => @note.description, :layout=>false    
    end
  end
  
  def update_position
  	@note = current_user.notes.find(params[:id])
	if !@note.nil?
	  	@note.x = params[:x]
  		@note.y = params[:y]
  		@note.z = params[:z]
  		@note.save
	end
	render :nothing => true
  end
  
  def update_color
  
  end
  
  def add_tag 
   @notes = current_user.notes
   note = Note.find(params[:id]) 
   note.taggings.each{|n| n.destroy}

   if params[:value].blank? || params[:value] == 'add tags to this note'
     render :text => 'add tags to this note'
   else
     
     
     tagArray = params[:value].split(" ")
     tagArray.each do | tag |
       if note.tags.find_by_name(tag) != nil
       else
         note.tag_with(tag)        
       end
     end
           
     
     note = current_user.notes.find(params[:id])      
     render :update do |page|
       page.replace_html('tags' + params[:id].to_s, note.tags.collect{|tag| tag.name}.join(", "))
       page.replace_html('cloud', generate_tag_cloud())
     end
   end
  
  end

  def search_by_tag
    @notes = if tag_name = params[:tag_search] 
    begin
    Tag.find_by_name(tag_name).tagged 
    rescue
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'index'
    end
    else 
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'index'
    end 
  end  

  def destroy
    @note = Note.find(params[:id])
    tag_count = @note.taggings.length()
    
    @note.destroy

    render :update do |page|
      if tag_count > 0 
        page.replace_html('cloud', generate_tag_cloud())
        #page.visual_effect(:shake, 'cloud')
      end    
      page.remove('note'+@note.id.to_s)
      page.remove('inner_note'+@note.id.to_s)
      page.remove('shadow'+@note.id.to_s)
    end
  end
  
  def add_file
 	  @note = current_user.notes.find(params[:id])
	  @note_file = @note.note_files.build
	  @note_file.save unless !@note_file.add_file(params[:note_file][:file])
      render :partial => 'uploading_progress', :object => @note
  end 
  
  def check_for_file    
    @note = current_user.notes.find(params[:id])
    if File.exists?("tmp/#{@note.id}")
      File.delete("tmp/#{@note.id}")
      render :text => "window.location='/notes/file_upload_control_done/#{@note.id}';",
                      :layout => false
    else
      render :nothing => true
    end
  end
  
  def delete_file
    @note = current_user.notes.find(params[:id])
    @note_file = @note.note_files.find(params[:note_file_id])
    @note_file.destroy
    redirect_to :action => 'home'
  end
  
  def file_upload_control   
    @note = current_user.notes.find(params[:id]) 
    render :partial => 'file_upload_control', :object => @note
  end
  
  def file_upload_control_done   
    @note = current_user.notes.find(params[:id]) 
    render :partial => 'file_upload_control_done', :object => @note
  end

  def get_file
	@note_file = current_user.notes.find(params[:id]).note_files.find(params[:file_id])	  
  	if params[:type].nil? 
	  send_file (RAILS_ROOT + "/files/" + @note_file.systempath + @note_file.filename, :disposition => 'inline', :type => @note_file.filetype)
	else
	  send_file (RAILS_ROOT + "/files/" + @note_file.systempath + "thumb_" + @note_file.filename, :disposition => 'inline', :type=>@note_file.filetype)
	end
  end
  
end
