set :application, "fringe_submit"

set :scm, :git
set :repository, "git@github.com:RevWorks/fringe_submit.git"
set :branch, "master"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :scm_verbose, true

role :app, "frodo.revworks.biz"
role :web, "frodo.revworks.biz"
role :db,  "frodo.revworks.biz", :primary => true
set :deploy_to, "/var/www/#{application}"

namespace :deploy do
  task :restart do
    sudo '/etc/init.d/apache2 restart'
  end
  
  task :start do
    sudo '/etc/init.d/apache2 start'
  end
  
  task :stop do
    sudo '/etc/init.d/apache2 stop'
  end
end