class ProfileController < ApplicationController
  before_filter :login_required
  
  def index
    if request.get?
      @user_profile = current_user.profile || current_user.create_profile
    else
      current_user.profile.update_attributes(params[:user_profile]) unless current_user.profile.nil?
      @user_profile = current_user.profile || current_user.create_profile

      unless params[:attachment][:picture].nil? 
        @user_profile.update_picture(params[:attachment][:picture])
      end

      unless params[:attachment][:resume].nil? 
        @user_profile.update_resume(params[:attachment][:resume])
      end
      
      flash[:notice] = "data saved"
    end  
  end
  
  
  # return the profile image
	def display_picture
	  profile_picture = Profile.find_by_id(params[:id]).picture
        send_data(profile_picture.attachment_binary.data,
				    :filename => profile_picture.name,
				    :type => profile_picture.content_type,
				    :disposition => "inline"
				    )
  end
  
  # return the profile resume
	def display_resume
	  profile_resume = Profile.find_by_id(params[:id]).resume
        send_data(profile_resume.attachment_binary.data,
				    :filename => profile_resume.name,
				    :type => profile_resume.content_type,
				    :disposition => "attachment"
				    )
  end
    
end
