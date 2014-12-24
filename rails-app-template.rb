# rails-app-template.rb
# Usage: rails new app-name --database=postgresql -m ./rails-app-templates/rails-app-template.rb

# Ask about publishing
publish = yes? "Do you want to publish to Heroku?"
if publish
  appname = ask("What do you want to call this app?")
end

# Ask the name of the app for Heroku
haml = yes? "Do you want to use HAML for templating?"
if haml
  gem "haml"
  gem "haml-rails"
end

# Add commonly used gems
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

# Stub out a controller and update the route
generate :controller, "Demos index show"
route "root to: 'demos#index'"

# hide secret data from git
# append_file '.gitignore', 'config/database.yml'
# append_file '.gitignore', '.env'

# Make an env file
run "touch .env"
# append_file '.env', 'PORT=3000'

# Create a default files
run "cp ~/Projects/rails-app-templates/scripts.coffee app/assets/javascripts/scripts.coffee"
run "cp -f ~/Projects/rails-app-templates/application.html.erb app/views/layouts/application.html.erb"

if haml
  run "rails generate haml:application_layout convert"
  remove_file "app/views/layouts/application.html.erb"
end

# Do the initial commit
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

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
# run "open http://localhost:3000"
