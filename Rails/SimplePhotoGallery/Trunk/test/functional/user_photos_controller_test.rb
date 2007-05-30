require File.dirname(__FILE__) + '/../test_helper'

context  "A controller for User Photos" do
  use_controller UserPhotosController
  fixtures :users, :photos, :albums

  setup do
    user = users(:quentin)
    @controller.stubs(:current_user).returns(user)
  end
  
  specify "should route by user" do
    options = {:controller=>'user_photos', :action=>'index', :user_id => users(:quentin).id.to_s}
    assert_routing('users/1/photos', options)

    options = {:controller=>'user_photos', :action=>'index', :user_id => users(:aaron).id.to_s}
    assert_routing('users/2/photos', options)
  end
  
  specify "should show paginated list of user photos" do
    get :index, :user_id => @controller.current_user
    
  end
  
  
end

