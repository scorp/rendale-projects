ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  
  map.resources :albums do |albums|
    albums.resources :photos, :name_perfix => "album_", :controller => "album_photos"
  end
  
  map.resources :users, :member=> {:signup => :get} do |users|
    users.resources :photos, :name_prefix => "user_", :controller => "user_photos"
    users.resources :albums, :name_prefix => "user_", :controller => "user_albums"
  end

  map.resources :sessions
  
  map.resources :photos

  map.index '/', :controller=>"sessions", :action=>"new"  
  #map.signup '/signup', :controller => 'users', :action => 'new'
  # map.login '/login', :controller => 'sessions', :action => 'new'
  # map.logout '/logout', :controller => 'sessions', :action=> 'destroy'

  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  #map.connect ':controller/:action/:id.:format'
  #map.connect ':controller/:action/:id'
end
