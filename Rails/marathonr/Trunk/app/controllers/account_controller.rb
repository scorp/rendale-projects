class AccountController < ApplicationController
  model :user

  def login
    case @request.method
      when :post
        if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])

          flash['notice']  = "Login successful"
          redirect_back_or_default :controller => "log", :action => "index"          
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
          redirect_back_or_default :controller => "log", :action => "index"          
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
    redirect_back_or_default :controller => "marathonr", :action => "index"
  end  
    
  def logout
    @session['user'] = nil
    redirect_to :controller => "account", :action=>"login"
  end
    
  def welcome
  end
  
end
