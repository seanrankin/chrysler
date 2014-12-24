# rails-app-template.rb
# Usage: rails new app-name --database=postgresql -m ./rails-app-templates/rails-app-template.rb

# Ask the name of the app for Heroku
appname = ask("What do you want to call this app?")

# Add commonly used gems
# gem 'haml'
# gem 'haml-rails'
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
generate(:scaffold, "User name:string")

rake("db:migrate")
rake("db:seed")

run "rails g bootstrap:themed Users -f"

# Update the default root
route "root to: 'users#index'"

# hide secret data from git
# append_file '.gitignore', 'config/database.yml'
# append_file '.gitignore', '.env'

# Make an env file
run 'touch .env'
# append_file '.env', 'PORT=3000'

# Create a default files
run "cp ~/Projects/rails-app-templates/scripts.coffee app/assets/javascripts/scripts.coffee"
run "cp -f ~/Projects/rails-app-templates/application.html.erb app/views/layouts/application.html.erb"

# Do the initial commit
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

# Create and push to heroku
run "heroku create #{appname}"
run "git push heroku master"
run "heroku run rake db:migrate"
run "heroku run rake db:seed"
run "heroku open --app #{appname}"

# Open project in Atom
run "atom ."

run "rails s"
# run "open http://localhost:3000"
