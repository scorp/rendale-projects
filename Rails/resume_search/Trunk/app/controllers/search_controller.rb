class SearchController < ApplicationController
  layout "main"
  
  def index
    @keywords = params[:search][:keywords] unless params[:search].nil? or params[:search][:keywords].nil?
    @resumes = Resume.find_by_contents(@keywords) unless @keywords.nil?
  end
    
  def view
    @resume = Resume.find(params[:id])
    send_data(@resume.data,
		    :filename => @resume.name,
		    :type => @resume.content_type,
		    :disposition => "attachment"
		    )
  end
    
end
