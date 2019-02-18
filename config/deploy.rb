lock '3.4.1'

def deploysecret(key)
  @deploy_secrets_yml ||= YAML.load_file('config/deploy-secrets.yml')[fetch(:stage).to_s]
  @deploy_secrets_yml.fetch(key.to_s, 'undefined')
end

set :rails_env, fetch(:stage)
set :rvm_ruby_version, '2.2.3'
set :rvm_type, :user

set :application, 'transparencia'
set :full_app_name, deploysecret(:full_app_name)

set :server_name, deploysecret(:server_name)
#set :repo_url, 'git@github.com:AyuntamientoMadrid/transparencia.git'
# If ssh access is restricted, probably you need to use https access
set :repo_url, 'https://github.com/AyuntamientoMadrid/transparencia.git'

set :scm, :git
set :revision, `git rev-parse --short #{fetch(:branch)}`.strip

set :log_level, :info
set :pty, true
set :use_sudo, false

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp public/system public/assets}
set :symlinks, %w{log tmp public/system public/assets}

set :keep_releases, 5

set :local_user, ENV['USER']

# Config files should be copied by deploy:setup_config
set(:config_files, %w(
  log_rotation
  database.yml
  secrets.yml
  unicorn.rb
  sidekiq.yml
))

namespace :deploy do
  after :finishing, 'deploy:cleanup'
  after 'deploy:publishing', 'deploy:restart'
end
