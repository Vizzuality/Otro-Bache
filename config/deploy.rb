require 'capistrano/ext/multistage'

set :stages, %w(staging production)
set :default_stage, "production"

require "bundler/capistrano"

default_run_options[:pty] = true

set :application, 'otrobache'

set :scm, :git
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :scm_user, 'ubuntu'
set :repository, "git://github.com/Vizzuality/Otro-Bache.git"
ssh_options[:forward_agent] = true
set :keep_releases, 5

set :linode_staging, '178.79.131.104'
set :linode_production, '178.79.142.149'
set :user,  'ubuntu'

set :deploy_to, "/home/ubuntu/www/#{application}"

after  "deploy:update_code", :run_migrations

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
end

desc "Migraciones"
task :run_migrations, :roles => [:app] do
  run <<-CMD
    export RAILS_ENV=production &&
    cd #{release_path} &&
    rake db:migrate
  CMD
end
 