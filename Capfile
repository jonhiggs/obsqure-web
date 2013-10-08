load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

before "deploy", "deploy:web:disable"

### FOREMAN ############################
require 'capistrano/foreman'

# Default settings
set :foreman_sudo, 'sudo'                    # Set to `rvmsudo` if you're using RVM
set :foreman_upstart_path, '/etc/init' # Set to `/etc/init/` if you don't have a sites folder
set :foreman_options, {
  app: application,
  log: "#{shared_path}/log",
  user: user,
}

after "deploy", "deploy:web:enable"
############################################
