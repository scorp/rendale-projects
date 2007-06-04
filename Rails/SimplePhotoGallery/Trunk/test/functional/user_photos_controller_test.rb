require File.dirname(__FILE__) + '/../test_helper'

context  "A controller for User Photos" do
  use_controller UserPhotosController
  fixtures :users, :photos, :albums

  setup do
    user = users(:quentin)
    #@controller.stubs(:current_user).returns(user)
  end
  
  specify "should route by user" do
    options = {:controller=>'user_photos', :action=>'index', :user_id => users(:quentin).id.to_s}
    assert_routing('users/1/photos', options)

    options = {:controller=>'user_photos', :action=>'index', :user_id => users(:aaron).id.to_s}
    assert_routing('users/2/photos', options)
  end
  
  specify "should require authentication for update access" do
    post :create, :user_id => users(:aaron)
    assert_redirected_to :controller=>"sessions", :action=>"new"
    
    # get :edit, :user_id => users(:aaron), :photo_id=> photos(:quentin_one)
    # assert_redirected_to :controller=>"sessions", :action=>"new"

    # put :update, :user_id => users(:aaron), :photo_id=> photos(:quentin_one)
    # assert_redirected_to :controller=>"sessions", :action=>"new"

    get :new, :user_id => users(:aaron)
    assert_redirected_to :controller=>"sessions", :action=>"new"

    # delete :destroy, :user_id => users(:aaron), :photo_id=> photos(:quentin_one)
    # assert_redirected_to :controller=>"sessions", :action=>"new"
  end
  
  specify "should show paginated list of user photos" do
    get :index, :user_id => users(:aaron)    
    assert_response :success    
  end
    
  xspecify "should provide rss feed by user" do
    
  end
  
end

