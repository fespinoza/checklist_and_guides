require "bundler/capistrano"

load 'config/recipes/base'
load 'config/recipes/nginx'
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "$SERVER", :web, :app, :db, primary: true

set :application, "$APP_NAME"
set :user, "$USER"
set :deploy_to, "$DEPLOY_PATH" # "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "$GIT_REPO"
set :branch, "GIT_BRANCH"

# to redirect the password prompt when using sudo on the server
default_run_options[:pty] = true
# to enable using local ssh keys to deploy in a remote machine
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
