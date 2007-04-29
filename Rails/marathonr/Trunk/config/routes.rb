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

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect "date/",
              :controller => "log",
              :action => "index"
              
  map.connect "date/:year/:month/:day",
              :controller => "log",
              :action => "index",
              :requirements => {:year => /(19|20)\d\d/,
                                :month => /[10]?\d/,
                                :day => /[0-3]?\d/},
              :day => nil,
              :month => nil 
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => "account", :action => "login"
  map.connect "signup", :controller => "account", :action => "signup"
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
            
end
