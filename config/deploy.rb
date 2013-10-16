require 'bundler/capistrano'

set :application, "obsqure"
set :repository,  "git@git.obsqure.net:/srv/git/repos/obsqure.git"
set :scm, :git
set :user, "www-data"
set :use_sudo, false

set :deploy_to, "/srv/www/obsqure"

role :web, "www.obsqure.net"                          # Your HTTP server, Apache/etc
role :app, "www.obsqure.net"                          # This may be the same as your `Web` server
role :db,  "www.obsqure.net", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
