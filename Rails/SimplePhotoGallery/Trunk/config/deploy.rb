set :application, "YAPA"
set :repository,  "http://code.rendale.com/svn/Rails/SimplePhotoGallery/Trunk/"
set :deploy_to, "~/dev/yapa/"
set :user, "yapa"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "yapa.rendale.com"
role :web, "yapa.rendale.com"
role :db,  "yapa.rendale.com", :primary => true

