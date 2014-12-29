#!/usr/bin/env ruby
# rails-app-template.rb
# Usage: rails new app-name --database=postgresql -m https://raw.githubusercontent.com/seanrankin/chrysler/master/chrysler.rb

# Get the path of the application template
path = File.expand_path File.dirname(__FILE__)
remotePath = "https://raw.githubusercontent.com/seanrankin/chrysler/master"

publish = yes? "Do you want to deploy to Heroku?"
if publish
  appname = ask("What do you want to name this app?")
end

root_controller = yes? "Should we create a default controller?"
if root_controller
  root_controller_name = ask("What is the root controllers name?").underscore
end

haml = yes? "Do you want to use HAML for templating?"
if haml
  gem "haml"
  gem "haml-rails"
end

# Add commonly used gems
# gem('compass-rails', group: :assets)
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem "jquery-datatables-rails"

gem_group :production, :staging do
  gem "rails_12factor"
end

gem_group :development do
  gem "quiet_assets" # removes asset pipline messages in development making the log easier to read
end

# Get rid of sqlite
gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''

# Set ruby version for Heroku
# insert_into_file 'Gemfile', "\nruby '2.0.0'", after: "source 'https://rubygems.org'\n"

# Bundle!
run "bundle install"

# Just in case, drop before creating the DB
rake("db:drop")
rake("db:create")

# Add default controller
if root_controller
  generate :controller, "#{root_controller_name} index"
  route "root to: '#{root_controller_name}\#index'"
end

# Install Bootstrap 3 with Less
run "rails generate bootstrap:install less"
run "rails g bootstrap:layout application -f"

# Install DataTables
run "rails generate jquery:datatables:install bootstrap3"

# Generate some test scaffolding
# generate(:scaffold, "User name:string")

rake("db:migrate")
rake("db:seed")

# run "rails g bootstrap:themed Users -f"

# Utility files
run "touch .env"
run "touch Procfile"
run "touch Guardfile"

# Create a default script file
run "curl -o app/assets/javascripts/scripts.coffee #{remotePath}/scripts.coffee"
# run "curl -o app/views/layouts/application.html.erb #{remotePath}/application.html.erb"

if haml
  run "rails generate haml:application_layout convert"
  remove_file "app/views/layouts/application.html.erb"
end

# Add git
git :init
# Hide secret data from git
append_file ".gitignore", "config/database.yml"
append_file ".gitignore", ".env"
# Run initial commit
git add: ".", commit: "'-m initial commit'"

# Create and push to heroku
if publish
  run "heroku create #{appname}"
  run "git push heroku master"
  run "heroku run rake db:migrate"
  run "heroku run rake db:seed"
  run "heroku open --app #{appname}"
end

# Open project in Atom
run "atom ."

run "rails s"
