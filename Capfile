load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

before "deploy", "deploy:web:disable"
after "deploy", "deploy:assets:precompile"
after "deploy", "deploy:submodule:update"
after "deploy", "deploy:web:enable"
after "deploy", "foreman:restart"
after "deploy", "deploy:assets:error_pages"

### DEPLOY #############################
namespace :deploy do
  namespace :assets do
    desc "Compile the static assets"
    task :precompile, :roles => :app do
      run("cd #{deploy_to}/current; /usr/local/bin/rake assets:precompile RAILS_ENV=#{rails_env}")  
    end

    desc "Generate Error Pages"
    task :error_pages, :roles => :app do
      run("cd #{deploy_to}/current/public; curl https://www.obsqure.net/access-denied > 422.html")
      run("cd #{deploy_to}/current/public; curl https://www.obsqure.net/file-not-found > 404.html")
      run("cd #{deploy_to}/current/public; curl https://www.obsqure.net/internal-server-error > 500.html")
      run("cd #{deploy_to}/current/public; curl https://www.obsqure.net/maintenance > 503.html")
    end
  end

  namespace :submodule do
    desc "Update submodules"
    task :update, :roles => :app do
      run("cd #{deploy_to}/current; git submodule init && git submodule update")
    end
  end

  namespace :web do
    desc "Turn off Maintenance Mode"
    task :enable, :roles => :app do
      run ("rm /srv/www/obsqure/shared/system/maintenance.txt")
    end

    desc "Turn on Maintenance Mode"
    task :disable, :roles => :app do
      run ("touch /srv/www/obsqure/shared/system/maintenance.txt")
    end
  end
end

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

namespace :foreman do
  namespace :nginx do
    desc "Start Nginx"
    task :start, :roles => :app do
      sudo "start nginx"
    end

    desc "Stop Nginx"
    task :stop, :roles => :app do
      sudo "stop nginx"
    end

    desc "Restart Nginx"
    task :restart, :roles => :app do
      sudo "restart nginx"
    end
  end
end
 
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
