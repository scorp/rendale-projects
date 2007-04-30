class NotesController < ApplicationController
before_filter :login_required  
  
  def index
    redirect_to :controller=> 'notes', :action => 'home'
  end
  
  def search_by_tag
    @notes = if tag_name = params[:tag_search] 
    begin
    Tag.find_by_name(tag_name).tagged 
    rescue
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'home'
    end
    else 
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'home'
    end 
  end  
  
  def home
    @current_user = session['user']  
    @notes = @current_user.notes.find(:all,:order => "date desc, id desc")
  end

  def show
      @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
    @note.description = "Sample text for your new note"
    @note.date = Time.now
    @note.user_id = session['user'].id
    @note.save
    @new_style = 'style="display:none"'
    render :update do |page|
      page.insert_html(:top, 'notes_block', :partial => 'note_listing', :object => @note)
      page.visual_effect(:slideDown, 'note' + @note.id.to_s)
    end

  end
  
  def update_descr
    @note = Note.find(params[:id])
    @note.description=params[:value]
    @note.save   
    render :text=> RedCloth.new(@note.description).to_html, :layout=>false
  end
  
  def get_descr
    @note = Note.find(params[:id])
    render :text=> @note.description, :layout=>false
  end
  
  def tag 
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

     note.save
     
     #todo do I need this?
     note = Note.find(params[:id]) 
     
     #respond
     render :update do |page|
       page.replace_html('tags' + params[:id].to_s, note.tags.collect{|tag| tag.name}.join(", "))
       page.replace_html('cloud', generate_tag_cloud())
       page.visual_effect(:shake, 'cloud')
     end
   end
  
  end

  def destroy
    @note = Note.find(params[:id])
    tag_count = @note.taggings.length()
    
    @note.destroy

    render :update do |page|
      if tag_count > 0 
        page.replace_html('cloud', generate_tag_cloud())
        page.visual_effect(:shake, 'cloud')
      end    
      page.visual_effect(:fade, 'note'+@note.id.to_s)
      page.visual_effect(:fade, 'inner_note'+@note.id.to_s)
      page.visual_effect(:fade, 'shadow'+@note.id.to_s)

    end

  end
  
  def add_file
 	  @note = Note.find(params[:id])
	  @note_file = @note.note_files.create
	  @note_file.save unless not @note_file.add_file(params[:note_file][:file])

    render :partial => 'uploading_progress', :object => @note
  end 
  
  def check_for_file    
    @note = Note.find(params[:id])
    if File.exists?("tmp/#{@note.id}")
      File.delete("tmp/#{@note.id}")
      render :text => "window.location='/notes/file_upload_control_done/#{@note.id}';",
                      :layout => false
    else
      render :nothing => true
    end
  
  end
  
  def delete_file
    @note = Note.find(params[:id])
    @note_file = @note.note_files.find(params[:note_file_id])
    @note_file.destroy
    redirect_to :action => 'home'
  end
  
  def file_upload_control   
    @note = Note.find(params[:id]) 
    render :partial => 'file_upload_control', :object => @note
  end
  
  def file_upload_control_done   
    @note = Note.find(params[:id]) 
    render :partial => 'file_upload_control_done', :object => @note
  end
  
end