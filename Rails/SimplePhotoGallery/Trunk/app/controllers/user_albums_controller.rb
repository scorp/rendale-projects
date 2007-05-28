class UserAlbumsController < ApplicationController
  layout 'shared'
  before_filter :login_required, :only => [ :new, :edit, :create, :destroy ]
  before_filter :find_user
  
  def index
  end
  
  def new
  end
  
  def find_user
    @user = User.find_by_id(params[:user_id])
  end
  
end
