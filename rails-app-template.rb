# rails-app-template.rb
# Usage: rails new app-name --database=postgresql -m ./rails-app-templates/rails-app-template.rb

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

route "root to: 'users#index'"

# $ ->                                                                                                                                                                                    #Load fancybox iframes to browser size
# # Inititate the datatable
# $('.datatable').DataTable()

# hide secret data from git
# append_file '.gitignore', 'config/database.yml'
# append_file '.gitignore', '.env'
# run 'cp config/database.yml config/example_database.yml'

# Make an env file
run 'touch .env'

# Do the initial commit
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

# heroku login
run "heroku create"
run "git push heroku master"
run "heroku run rake db:migrate"
run "heroku run rake db:seed"

# Open project
run "atom ."

run "rails s"
