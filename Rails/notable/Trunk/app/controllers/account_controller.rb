class AccountController < ApplicationController
  model   :user
  layout 'account'

  def login
    case @request.method
      when :post
        if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])

          flash['notice']  = "Login successful"
          redirect_back_or_default :action => "welcome"
        else
          @login    = @params['user_login']
          @message  = "Login unsuccessful"
      end
    end
  end
  
  def signup
    case @request.method
      when :post
        @user = User.new(@params['user'])
        
        if @user.save      
          @session['user'] = User.authenticate(@user.login, @params['user']['password'])
          flash['notice']  = "Signup successful"
          redirect_back_or_default :controller=> "notes", :action => 
"index"          
        end
      when :get
        @user = User.new
    end      
  end  
  
  def delete
    if @params['id']
      @user = User.find(@params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "index"
  end  
    
  def logout
    @session['user'] = nil 
    @message = "You have logged out of Notable"
  	render :action=>'login'
  end
    
  def welcome
    redirect_to :controller=>'notes', :action=>'index'
  end
  
  def account
  end
  
end
