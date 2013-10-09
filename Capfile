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

desc "tail production log files" 
task :tail_logs, :roles => :app do
  trap("INT") { puts 'Interupted'; exit 0; }
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err
  end
end
