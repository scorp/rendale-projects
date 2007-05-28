require File.dirname(__FILE__) + '/../test_helper'

context  "A controller for User Photos" do
  use_controller UserPhotosController

  setup do
    @user = User.find(:first)
    @controller.stubs(:current_user).returns(@user)
  end
  
  xspecify "should show paginated list of user photos" do

  end
  
  
end

