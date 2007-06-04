class UsersController < ApplicationController
  before_filter :login_required, :except=>[:new, :create]
  layout "shared"
  
  # render new.rhtml
  def new
    
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default(user_photos_path(current_user))
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end
  
  def show
  end
  
  def edit
    @user = current_user
    @avatar = current_user.avatar || current_user.build_avatar
  end
  
  def update
    @user = current_user    
    @avatar = current_user.avatar || current_user.build_avatar
    respond_to do |format|
      if @user.update_attributes(params[:user]) && @avatar.update_attributes(params[:avatar])
          flash[:notice] = "Your user information has been saved."
          format.html {redirect_to edit_user_path(current_user)}
      else
          format.html {render :action => "edit"}
      end
    end
  end

end
