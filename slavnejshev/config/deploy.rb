# config valid only for current version of Capistrano
lock '3.6.1'

set :repo_url, 'https://github.com/TheMrButcher/website.git'
set :repo_tree, 'slavnejshev'
set :application, 'slavnejshev'
application = 'slavnejshev'
set :rvm_type, :user
set :rvm_ruby_version, '2.3.0-p0'
set :deploy_to, '/var/www/apps/slavnejshev'
set :bundle_flags, '--quiet'

namespace :foreman do
  desc 'Start server'
  task :start do
    on roles(:all) do
      sudo "systemctl start #{application}.target"
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:all) do
      sudo "systemctl stop #{application}.target"
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:all) do
      sudo "systemctl restart #{application}.target"
    end
  end

  desc 'Server status'
  task :status do
    on roles(:all) do
      execute "systemctl | grep #{application}.target"
    end
  end
end

namespace :git do
  desc 'Deploy'
  task :deploy do
    ask(:message, "Commit message?")
    run_locally do
      execute "git add --all :/"
      execute "git commit -m \"#{fetch(:message)}\""
      execute "git push origin master"
    end
  end
end

namespace :deploy do
  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/config/"
      execute "mkdir -p /var/www/apps/#{application}/run/"
      execute "mkdir -p /var/www/apps/#{application}/log/"
      execute "mkdir -p /var/www/apps/#{application}/socket/"
      execute "mkdir -p #{shared_path}/system"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/Procfile', "#{shared_path}/Procfile")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      
      sudo 'systemctl stop nginx'
      sudo "rm -f /etc/nginx/nginx.conf"
      sudo "ln -s #{shared_path}/nginx.conf /etc/nginx/nginx.conf"
      sudo 'systemctl start nginx'
    end
  end

  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/Procfile #{release_path}/Procfile"
      execute "ln -s #{shared_path}/system #{release_path}/public/system"
    end
  end
  
  desc 'Create DB'
  task :create_db do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = "/var/www/tmp/foreman"
      execute  "mkdir -p #{foreman_temp}"
      execute "ln -s #{release_path} #{current_path}"

      within current_path do
        execute "cd #{current_path}"
        execute :bundle, "exec foreman export systemd #{foreman_temp} -a #{application} -u deploy -l /var/www/apps/#{application}/log -d #{current_path}"
      end
      sudo "rsync -a #{foreman_temp}/ /lib/systemd/system/"
      sudo "rm -r #{foreman_temp}"
    end
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "systemctl restart #{application}"
    end
  end

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'
  after :setup, 'deploy:symlink'
  after :symlink, 'deploy:create_db'
  before :foreman_init, 'rvm:hook'
  after :setup, 'deploy:foreman_init'
  after :foreman_init, 'foreman:start'
  after :finishing, 'deploy:cleanup'
  after :cleanup, 'deploy:restart'
end
  
before :deploy, 'git:deploy'
