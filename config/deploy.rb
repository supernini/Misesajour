set :rvm_ruby_string, '1.9.2'
require "bundler/capistrano"
require "rvm/capistrano"
set :rvm_type, :system
set :application, "Misesajour"
set :repository,  "git@bitbucket.org:supernini/misesajour.git"
set :scm, :git
set :user, :root
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, '/home/httpd/vhosts/Misesajour'
default_run_options[:pty] = true

role :web, "lasagne"                          # Your HTTP server, Apache/etc
role :app, "lasagne"                          # This may be the same as your `Web` server
role :db,  "lasagne", :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "Restart Thin"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && bundle exec thin restart -C #{deploy_to}/current/config/thin.yml"
  end
end